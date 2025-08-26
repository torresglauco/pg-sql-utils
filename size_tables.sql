/*
 * PostgreSQL Script: Table Size Analysis
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive table size analysis with indexes and statistics
 */

-- Comprehensive table size analysis
SELECT 
    schemaname AS schema_name,
    tablename AS table_name,
    -- Size information
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) AS indexes_size,
    -- Raw bytes for calculations
    pg_total_relation_size(schemaname||'.'||tablename) AS total_bytes,
    pg_relation_size(schemaname||'.'||tablename) AS table_bytes,
    -- Row statistics
    COALESCE(pg_stat_user_tables.n_live_tup, 0) AS live_rows,
    COALESCE(pg_stat_user_tables.n_dead_tup, 0) AS dead_rows,
    CASE 
        WHEN pg_stat_user_tables.n_live_tup > 0 
        THEN pg_relation_size(schemaname||'.'||tablename) / pg_stat_user_tables.n_live_tup
        ELSE 0 
    END AS avg_row_size_bytes,
    -- Activity statistics
    COALESCE(pg_stat_user_tables.seq_scan, 0) AS sequential_scans,
    COALESCE(pg_stat_user_tables.seq_tup_read, 0) AS sequential_tuples_read,
    COALESCE(pg_stat_user_tables.idx_scan, 0) AS index_scans,
    COALESCE(pg_stat_user_tables.idx_tup_fetch, 0) AS index_tuples_fetched,
    COALESCE(pg_stat_user_tables.n_tup_ins, 0) AS rows_inserted,
    COALESCE(pg_stat_user_tables.n_tup_upd, 0) AS rows_updated,
    COALESCE(pg_stat_user_tables.n_tup_del, 0) AS rows_deleted,
    COALESCE(pg_stat_user_tables.n_tup_hot_upd, 0) AS hot_updates,
    -- Maintenance information
    pg_stat_user_tables.last_vacuum,
    pg_stat_user_tables.last_autovacuum,
    pg_stat_user_tables.last_analyze,
    pg_stat_user_tables.last_autoanalyze
FROM 
    pg_tables
    LEFT JOIN pg_stat_user_tables 
        ON pg_tables.schemaname = pg_stat_user_tables.schemaname 
        AND pg_tables.tablename = pg_stat_user_tables.relname
WHERE 
    pg_tables.schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
ORDER BY 
    pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Summary by schema
SELECT 
    'SCHEMA_SUMMARY' AS report_type,
    schemaname AS schema_name,
    COUNT(*) AS table_count,
    pg_size_pretty(SUM(pg_total_relation_size(schemaname||'.'||tablename))) AS total_size,
    pg_size_pretty(SUM(pg_relation_size(schemaname||'.'||tablename))) AS tables_size,
    pg_size_pretty(SUM(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename))) AS indexes_size
FROM 
    pg_tables
WHERE 
    schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
GROUP BY 
    schemaname
ORDER BY 
    SUM(pg_total_relation_size(schemaname||'.'||tablename)) DESC;
