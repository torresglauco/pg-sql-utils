/*
 * PostgreSQL Script: Performance Monitoring Dashboard
 * Author: Enhanced collection for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive performance monitoring queries
 */

-- Current database performance overview
SELECT 
    'DATABASE_PERFORMANCE' AS metric_category,
    current_database() AS database_name,
    pg_size_pretty(pg_database_size(current_database())) AS database_size,
    (SELECT COUNT(*) FROM pg_stat_activity WHERE datname = current_database()) AS total_connections,
    (SELECT COUNT(*) FROM pg_stat_activity WHERE datname = current_database() AND state = 'active') AS active_connections,
    (SELECT COUNT(*) FROM pg_stat_activity WHERE datname = current_database() AND state = 'idle') AS idle_connections,
    ROUND(
        (SELECT SUM(blks_hit) * 100.0 / NULLIF(SUM(blks_hit + blks_read), 0) 
         FROM pg_stat_database WHERE datname = current_database()), 2
    ) AS cache_hit_ratio_percent;

-- Lock analysis
SELECT 
    'LOCK_ANALYSIS' AS metric_category,
    pl.pid AS process_id,
    pa.usename AS username,
    pa.datname AS database,
    pa.client_addr AS client_address,
    pa.application_name,
    pl.mode AS lock_mode,
    pl.locktype AS lock_type,
    pl.granted AS lock_granted,
    pa.query AS current_query,
    NOW() - pa.query_start AS query_duration,
    pa.state AS connection_state
FROM 
    pg_locks pl
    LEFT JOIN pg_stat_activity pa ON pl.pid = pa.pid
WHERE 
    pa.datname = current_database()
    AND pa.pid != pg_backend_pid()  -- Exclude current session
ORDER BY 
    query_duration DESC NULLS LAST;

-- Table and index statistics for performance
SELECT 
    'TABLE_PERFORMANCE' AS metric_category,
    schemaname AS schema_name,
    tablename AS table_name,
    seq_scan AS sequential_scans,
    seq_tup_read AS seq_tuples_read,
    idx_scan AS index_scans,
    idx_tup_fetch AS idx_tuples_fetched,
    n_tup_ins AS rows_inserted,
    n_tup_upd AS rows_updated,
    n_tup_del AS rows_deleted,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    CASE 
        WHEN n_live_tup > 0 
        THEN ROUND((n_dead_tup * 100.0 / n_live_tup), 2)
        ELSE 0 
    END AS dead_rows_percentage,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size
FROM 
    pg_stat_user_tables
WHERE 
    schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
ORDER BY 
    pg_total_relation_size(schemaname||'.'||tablename) DESC;
