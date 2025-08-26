/*
 * PostgreSQL Script: Find Procedure/Function by Partial Name
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Search for procedures and functions containing partial text in name or source code
 */

-- Search for procedures and functions by partial name or content
-- This script provides multiple search options

-- Option 1: Search by partial procedure name
SELECT 
    'BY_NAME' AS search_type,
    n.nspname AS schema_name,
    p.proname AS procedure_name,
    pg_get_function_identity_arguments(p.oid) AS arguments,
    CASE 
        WHEN p.prokind = 'f' THEN 'FUNCTION'
        WHEN p.prokind = 'p' THEN 'PROCEDURE'
        WHEN p.prokind = 'a' THEN 'AGGREGATE'
        WHEN p.prokind = 'w' THEN 'WINDOW'
        ELSE 'OTHER'
    END AS procedure_type,
    l.lanname AS language
FROM 
    pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    INNER JOIN pg_language l ON p.prolang = l.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND p.proname ILIKE '%partial_name%'  -- Replace with partial name

UNION ALL

-- Option 2: Search by content in source code
SELECT 
    'BY_CONTENT' AS search_type,
    n.nspname AS schema_name,
    p.proname AS procedure_name,
    pg_get_function_identity_arguments(p.oid) AS arguments,
    CASE 
        WHEN p.prokind = 'f' THEN 'FUNCTION'
        WHEN p.prokind = 'p' THEN 'PROCEDURE'
        WHEN p.prokind = 'a' THEN 'AGGREGATE'
        WHEN p.prokind = 'w' THEN 'WINDOW'
        ELSE 'OTHER'
    END AS procedure_type,
    l.lanname AS language
FROM 
    pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    INNER JOIN pg_language l ON p.prolang = l.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND p.prosrc ILIKE '%search_text%'  -- Replace with text to search in source code
    
ORDER BY 
    search_type,
    schema_name, 
    procedure_name;
