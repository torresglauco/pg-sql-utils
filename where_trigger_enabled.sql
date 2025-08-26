/*
 * PostgreSQL Script: Trigger Analysis
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive analysis of triggers with detailed information
 */

-- Comprehensive trigger analysis
SELECT 
    n.nspname AS schema_name,
    c.relname AS table_name,
    t.tgname AS trigger_name,
    CASE t.tgtype & 66
        WHEN 2 THEN 'BEFORE'
        WHEN 64 THEN 'INSTEAD OF'
        ELSE 'AFTER'
    END AS trigger_timing,
    CASE t.tgtype & 28
        WHEN 4 THEN 'INSERT'
        WHEN 8 THEN 'DELETE'
        WHEN 16 THEN 'UPDATE'
        WHEN 12 THEN 'INSERT, DELETE'
        WHEN 20 THEN 'INSERT, UPDATE'
        WHEN 24 THEN 'DELETE, UPDATE'
        WHEN 28 THEN 'INSERT, DELETE, UPDATE'
        ELSE 'UNKNOWN'
    END AS trigger_events,
    CASE 
        WHEN t.tgtype & 1 = 1 THEN 'ROW'
        ELSE 'STATEMENT'
    END AS trigger_level,
    CASE 
        WHEN t.tgenabled = 'O' THEN 'ENABLED'
        WHEN t.tgenabled = 'D' THEN 'DISABLED'
        WHEN t.tgenabled = 'R' THEN 'REPLICA'
        WHEN t.tgenabled = 'A' THEN 'ALWAYS'
        ELSE 'UNKNOWN'
    END AS trigger_status,
    p.proname AS function_name,
    pg_get_userbyid(t.tgowner) AS trigger_owner,
    CASE 
        WHEN t.tgconstraint != 0 THEN 'YES'
        ELSE 'NO'
    END AS is_constraint_trigger,
    pg_get_triggerdef(t.oid) AS trigger_definition
FROM 
    pg_trigger t
    INNER JOIN pg_class c ON t.tgrelid = c.oid
    INNER JOIN pg_namespace n ON c.relnamespace = n.oid
    LEFT JOIN pg_proc p ON t.tgfoid = p.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND NOT t.tgisinternal  -- Exclude internal triggers
ORDER BY 
    n.nspname,
    c.relname,
    t.tgname;

-- Summary by status
SELECT 
    'TRIGGER_SUMMARY' AS report_type,
    CASE 
        WHEN t.tgenabled = 'O' THEN 'ENABLED'
        WHEN t.tgenabled = 'D' THEN 'DISABLED'
        WHEN t.tgenabled = 'R' THEN 'REPLICA'
        WHEN t.tgenabled = 'A' THEN 'ALWAYS'
        ELSE 'UNKNOWN'
    END AS status,
    COUNT(*) AS trigger_count
FROM 
    pg_trigger t
    INNER JOIN pg_class c ON t.tgrelid = c.oid
    INNER JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE 
    n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND NOT t.tgisinternal
GROUP BY 
    t.tgenabled
ORDER BY 
    trigger_count DESC;
