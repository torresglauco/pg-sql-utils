/*
 * PostgreSQL Script: Vacuum Analysis and Scheduling
 * Author: Database Enhancement Scripts
 * Compatible with: PostgreSQL 12+
 * Description: Identifies tables needing vacuum and recommends maintenance schedules
 * Usage: psql -f vacuum_analyzer.sql -d your_database
 */

-- Vacuum analysis and recommendations
SELECT
    current_database() AS database_name,
    schemaname AS schema_name,
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup, 0), 2) AS dead_row_percentage,
    CASE
        WHEN n_dead_tup > 10000 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 20 THEN 'HIGH - VACUUM REQUIRED'
        WHEN n_dead_tup > 1000 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 10 THEN 'MEDIUM - SCHEDULE VACUUM'
        WHEN n_dead_tup > 100 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 5 THEN 'LOW - MONITOR'
        ELSE 'NORMAL - NO ACTION NEEDED'
    END AS vacuum_priority,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || relname)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname || '.' || relname)) AS table_size
FROM 
    pg_stat_user_tables
WHERE
    n_live_tup > 0 OR n_dead_tup > 0
ORDER BY 
    dead_row_percentage DESC NULLS LAST,
    n_dead_tup DESC;

-- Vacuum recommendations summary
SELECT
    COUNT(*) AS total_tables,
    COUNT(*) FILTER (WHERE n_dead_tup > 10000 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 20) AS high_priority,
    COUNT(*) FILTER (WHERE n_dead_tup > 1000 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 10) AS medium_priority,
    COUNT(*) FILTER (WHERE n_dead_tup > 100 AND (n_dead_tup * 100.0 / NULLIF(n_live_tup, 0)) > 5) AS low_priority
FROM 
    pg_stat_user_tables
WHERE
    n_live_tup > 0 OR n_dead_tup > 0;
