/*
 * PostgreSQL Script: Find Procedure/Function by Name
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Search for stored procedures and functions by name pattern
 */

-- Search for procedures and functions by name pattern
-- Usage: Replace 'your_pattern' with the name or pattern you're looking for
-- Example: WHERE p.proname ILIKE '%user%'

SELECT 
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
    pg_get_userbyid(p.proowner) AS owner,
    l.lanname AS language,
    p.procost AS estimated_cost,
    p.prorows AS estimated_rows,
    pg_size_pretty(
        length(p.prosrc::text)
    ) AS source_code_size
FROM 
    pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    INNER JOIN pg_language l ON p.prolang = l.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND p.proname ILIKE '%your_pattern%'  -- Replace with your search pattern
ORDER BY 
    n.nspname, 
    p.proname;

-- Alternative query to show procedure source code
-- Uncomment the following lines to also display the source code

/*
SELECT 
    n.nspname AS schema_name,
    p.proname AS procedure_name,
    pg_get_functiondef(p.oid) AS full_definition
FROM 
    pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND p.proname ILIKE '%your_pattern%'  -- Replace with your search pattern
ORDER BY 
    n.nspname, 
    p.proname;
*/
