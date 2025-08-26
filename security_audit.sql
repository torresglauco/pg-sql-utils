/*
 * PostgreSQL Script: Security Audit and Analysis
 * Author: Enhanced collection for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive security audit for PostgreSQL databases
 */

-- User and role security analysis
SELECT 
    'USER_ANALYSIS' AS security_category,
    rolname AS role_name,
    CASE 
        WHEN rolsuper THEN 'SUPERUSER'
        ELSE 'REGULAR USER'
    END AS user_type,
    rolcreaterole AS can_create_roles,
    rolcreatedb AS can_create_databases,
    rolcanlogin AS can_login,
    rolreplication AS replication_privileges,
    rolbypassrls AS bypass_row_security,
    rolconnlimit AS connection_limit,
    CASE 
        WHEN rolpassword IS NOT NULL THEN 'HAS PASSWORD'
        ELSE 'NO PASSWORD'
    END AS password_status,
    rolvaliduntil AS password_expiry,
    CASE 
        WHEN rolvaliduntil IS NOT NULL AND rolvaliduntil < NOW() THEN 'EXPIRED'
        WHEN rolvaliduntil IS NOT NULL THEN 'VALID'
        ELSE 'NO EXPIRY'
    END AS password_validity
FROM 
    pg_roles
ORDER BY 
    rolsuper DESC,
    rolname;

-- Sensitive tables without proper security
SELECT 
    'SECURITY_CONCERNS' AS security_category,
    t.table_schema AS schema_name,
    t.table_name,
    CASE 
        WHEN t.table_name ILIKE '%password%' OR 
             t.table_name ILIKE '%user%' OR 
             t.table_name ILIKE '%auth%' OR 
             t.table_name ILIKE '%login%' OR
             t.table_name ILIKE '%security%' THEN 'POTENTIALLY SENSITIVE'
        ELSE 'REGULAR TABLE'
    END AS sensitivity_level,
    'Review access permissions for sensitive tables' AS recommendation
FROM 
    information_schema.tables t
WHERE 
    t.table_type = 'BASE TABLE'
    AND t.table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND (
        t.table_name ILIKE '%password%' OR 
        t.table_name ILIKE '%user%' OR 
        t.table_name ILIKE '%auth%' OR 
        t.table_name ILIKE '%login%' OR
        t.table_name ILIKE '%security%' OR
        t.table_name ILIKE '%credential%' OR
        t.table_name ILIKE '%token%'
    )
ORDER BY 
    sensitivity_level DESC,
    t.table_schema,
    t.table_name;

-- Function and procedure security
SELECT 
    'FUNCTION_SECURITY' AS security_category,
    n.nspname AS schema_name,
    p.proname AS function_name,
    pg_get_function_identity_arguments(p.oid) AS arguments,
    CASE 
        WHEN p.prosecdef THEN 'SECURITY DEFINER'
        ELSE 'SECURITY INVOKER'
    END AS security_type,
    pg_get_userbyid(p.proowner) AS owner,
    l.lanname AS language,
    CASE 
        WHEN p.prosecdef AND pg_get_userbyid(p.proowner) IN (
            SELECT rolname FROM pg_roles WHERE rolsuper = true
        ) THEN 'HIGH RISK - Security definer owned by superuser'
        WHEN p.prosecdef THEN 'MEDIUM RISK - Security definer function'
        ELSE 'LOW RISK'
    END AS security_risk_level
FROM 
    pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    INNER JOIN pg_language l ON p.prolang = l.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
ORDER BY 
    CASE 
        WHEN p.prosecdef AND pg_get_userbyid(p.proowner) IN (
            SELECT rolname FROM pg_roles WHERE rolsuper = true
        ) THEN 1
        WHEN p.prosecdef THEN 2
        ELSE 3
    END,
    n.nspname,
    p.proname;
