/*
 * PostgreSQL Script: Find Tables by Field/Column Name
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Search for tables containing specific column names with detailed information
 */

-- Search for tables containing a specific column/field name
-- Usage: Replace 'your_column_name' with the column name you're searching for

SELECT 
    t.table_schema AS schema_name,
    t.table_name,
    c.column_name,
    c.ordinal_position AS column_position,
    c.data_type,
    CASE 
        WHEN c.character_maximum_length IS NOT NULL 
        THEN c.data_type || '(' || c.character_maximum_length || ')'
        WHEN c.numeric_precision IS NOT NULL AND c.numeric_scale IS NOT NULL
        THEN c.data_type || '(' || c.numeric_precision || ',' || c.numeric_scale || ')'
        WHEN c.numeric_precision IS NOT NULL
        THEN c.data_type || '(' || c.numeric_precision || ')'
        ELSE c.data_type
    END AS full_data_type,
    c.is_nullable,
    c.column_default,
    CASE 
        WHEN pk.column_name IS NOT NULL THEN 'YES'
        ELSE 'NO'
    END AS is_primary_key,
    CASE 
        WHEN fk.column_name IS NOT NULL THEN 'YES'
        ELSE 'NO'
    END AS is_foreign_key,
    fk.foreign_table_schema,
    fk.foreign_table_name,
    fk.foreign_column_name,
    pg_size_pretty(pg_total_relation_size(t.table_schema||'.'||t.table_name)) AS table_size
FROM 
    information_schema.tables t
    INNER JOIN information_schema.columns c 
        ON t.table_name = c.table_name 
        AND t.table_schema = c.table_schema
    LEFT JOIN (
        -- Primary key information
        SELECT 
            tc.table_schema,
            tc.table_name,
            kcu.column_name
        FROM 
            information_schema.table_constraints tc
            INNER JOIN information_schema.key_column_usage kcu 
                ON tc.constraint_name = kcu.constraint_name 
                AND tc.table_schema = kcu.table_schema
        WHERE 
            tc.constraint_type = 'PRIMARY KEY'
    ) pk ON t.table_schema = pk.table_schema 
        AND t.table_name = pk.table_name 
        AND c.column_name = pk.column_name
    LEFT JOIN (
        -- Foreign key information
        SELECT 
            tc.table_schema,
            tc.table_name,
            kcu.column_name,
            ccu.table_schema AS foreign_table_schema,
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name
        FROM 
            information_schema.table_constraints tc
            INNER JOIN information_schema.key_column_usage kcu 
                ON tc.constraint_name = kcu.constraint_name 
                AND tc.table_schema = kcu.table_schema
            INNER JOIN information_schema.constraint_column_usage ccu 
                ON ccu.constraint_name = tc.constraint_name 
                AND ccu.table_schema = tc.table_schema
        WHERE 
            tc.constraint_type = 'FOREIGN KEY'
    ) fk ON t.table_schema = fk.table_schema 
        AND t.table_name = fk.table_name 
        AND c.column_name = fk.column_name
WHERE 
    t.table_type = 'BASE TABLE'
    AND t.table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND c.column_name ILIKE '%your_column_name%'  -- Replace with your search pattern
ORDER BY 
    t.table_schema,
    t.table_name,
    c.ordinal_position;
