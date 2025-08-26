/*
 * PostgreSQL Script: Data Privacy Compliance Checker
 * Author: Database Enhancement Scripts
 * Compatible with: PostgreSQL 12+
 * Description: Data privacy compliance assessment (GDPR, LGPD, CCPA compatible)
 * Usage: psql -f compliance_checker.sql -d your_database
 */

-- Identify potential personally identifiable information (PII)
WITH potential_pii_columns AS (
    SELECT 
        c.table_schema,
        c.table_name,
        c.column_name,
        c.data_type,
        CASE 
            WHEN c.column_name ILIKE ANY(ARRAY['%ssn%', '%social%', '%cpf%', '%rg%']) THEN 'NATIONAL_ID'
            WHEN c.column_name ILIKE ANY(ARRAY['%email%', '%mail%']) THEN 'EMAIL'
            WHEN c.column_name ILIKE ANY(ARRAY['%phone%', '%telefone%', '%mobile%']) THEN 'PHONE'
            WHEN c.column_name ILIKE ANY(ARRAY['%name%', '%nome%', '%first%', '%last%']) THEN 'NAME'
            WHEN c.column_name ILIKE ANY(ARRAY['%address%', '%endereco%', '%street%']) THEN 'ADDRESS'
            WHEN c.column_name ILIKE ANY(ARRAY['%birth%', '%nascimento%', '%dob%']) THEN 'BIRTH_DATE'
            WHEN c.column_name ILIKE ANY(ARRAY['%ip%', '%location%', '%geo%']) THEN 'LOCATION'
            WHEN c.column_name ILIKE ANY(ARRAY['%passport%', '%license%', '%document%']) THEN 'DOCUMENT'
            ELSE 'OTHER_SENSITIVE'
        END AS pii_category
    FROM 
        information_schema.columns c
    WHERE 
        c.table_schema NOT IN ('pg_catalog', 'information_schema')
        AND (
            c.column_name ILIKE ANY(ARRAY[
                '%ssn%', '%social%', '%cpf%', '%rg%',
                '%email%', '%mail%',
                '%phone%', '%telefone%', '%mobile%',
                '%name%', '%nome%', '%first%', '%last%',
                '%address%', '%endereco%', '%street%',
                '%birth%', '%nascimento%', '%dob%',
                '%ip%', '%location%', '%geo%',
                '%passport%', '%license%', '%document%'
            ])
        )
)
SELECT 
    p.table_schema,
    p.table_name,
    array_agg(p.column_name || ' (' || p.pii_category || ')') AS sensitive_columns,
    COUNT(*) AS pii_column_count,
    CASE 
        WHEN has_table_privilege(p.table_schema || '.' || p.table_name, 'SELECT') THEN 'ACCESSIBLE'
        ELSE 'RESTRICTED'
    END AS current_user_access,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.role_table_grants g
            WHERE g.table_schema = p.table_schema
              AND g.table_name = p.table_name
              AND g.grantee = 'PUBLIC'
              AND g.privilege_type = 'SELECT'
        ) THEN 'CRITICAL - Public read access detected'
        ELSE 'OK - No public access'
    END AS public_access_status
FROM 
    potential_pii_columns p
GROUP BY 
    p.table_schema, p.table_name
ORDER BY 
    COUNT(*) DESC, p.table_schema, p.table_name;

-- Check for encryption and security measures
SELECT 
    'PASSWORD COLUMNS' AS security_check,
    COUNT(*) AS found_items,
    'Verify password columns are properly hashed' AS recommendation
FROM 
    information_schema.columns
WHERE 
    column_name ILIKE ANY(ARRAY['%password%', '%passwd%', '%pwd%', '%hash%'])
    AND table_schema NOT IN ('pg_catalog', 'information_schema')

UNION ALL

SELECT 
    'AUDIT COLUMNS' AS security_check,
    COUNT(DISTINCT table_schema || '.' || table_name) AS found_items,
    'Tables with audit trail columns detected' AS recommendation
FROM 
    information_schema.columns
WHERE 
    column_name ILIKE ANY(ARRAY['%created%', '%updated%', '%modified%', '%audit%'])
    AND table_schema NOT IN ('pg_catalog', 'information_schema')

UNION ALL

SELECT 
    'SSL ENFORCEMENT' AS security_check,
    CASE WHEN setting = 'on' THEN 1 ELSE 0 END AS found_items,
    CASE WHEN setting = 'on' THEN 'SSL is enabled' ELSE 'Consider enabling SSL' END AS recommendation
FROM 
    pg_settings 
WHERE 
    name = 'ssl';

-- Data retention analysis
SELECT 
    c.table_schema,
    c.table_name,
    c.column_name AS date_column,
    c.data_type,
    'Review data retention policies for compliance' AS compliance_note
FROM 
    information_schema.columns c
WHERE 
    c.table_schema NOT IN ('pg_catalog', 'information_schema')
    AND c.data_type IN ('timestamp', 'timestamp with time zone', 'date')
    AND c.column_name ILIKE ANY(ARRAY['%created%', '%date%', '%time%'])
ORDER BY 
    c.table_schema, c.table_name, c.column_name;
