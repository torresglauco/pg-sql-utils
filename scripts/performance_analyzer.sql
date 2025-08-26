/*
 * PostgreSQL Script: Performance Analysis and Optimization
 * Author: Database Enhancement Scripts
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive performance analysis and optimization recommendations
 * Usage: psql -f performance_analyzer.sql -d your_database
 */

-- Top resource-consuming queries (requires pg_stat_statements)
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows,
    100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent,
    CASE 
        WHEN mean_time > 1000 THEN 'SLOW - Optimize immediately'
        WHEN mean_time > 100 THEN 'MEDIUM - Consider optimization'
        ELSE 'FAST - Good performance'
    END AS performance_status
FROM 
    pg_stat_statements 
WHERE 
    query NOT ILIKE '%pg_stat_statements%'
ORDER BY 
    total_time DESC 
LIMIT 20;

-- Index usage analysis
SELECT 
    schemaname AS schema_name,
    tablename AS table_name,
    indexname AS index_name,
    idx_tup_read AS index_reads,
    idx_tup_fetch AS index_fetches,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    CASE 
        WHEN idx_tup_read = 0 THEN 'UNUSED - Consider dropping'
        WHEN idx_tup_read < 1000 THEN 'LOW USAGE - Review necessity'
        ELSE 'ACTIVE - Keep index'
    END AS usage_recommendation
FROM 
    pg_stat_user_indexes
ORDER BY 
    idx_tup_read ASC;

-- Table statistics and bloat estimation
SELECT 
    schemaname AS schema_name,
    tablename AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS bloat_percentage,
    CASE 
        WHEN n_dead_tup > n_live_tup * 0.2 THEN 'HIGH BLOAT - Vacuum recommended'
        WHEN n_dead_tup > n_live_tup * 0.1 THEN 'MODERATE BLOAT - Monitor closely'
        ELSE 'LOW BLOAT - Normal'
    END AS bloat_status,
    last_vacuum,
    last_analyze
FROM 
    pg_stat_user_tables
WHERE 
    n_live_tup > 0
ORDER BY 
    bloat_percentage DESC NULLS LAST;

-- Connection and activity monitoring
SELECT 
    state,
    COUNT(*) AS connection_count,
    CASE 
        WHEN state = 'active' AND COUNT(*) > 50 THEN 'HIGH ACTIVITY - Monitor for bottlenecks'
        WHEN state = 'idle in transaction' AND COUNT(*) > 10 THEN 'WARNING - Many idle transactions'
        ELSE 'NORMAL'
    END AS status_assessment
FROM 
    pg_stat_activity
WHERE 
    datname = current_database()
GROUP BY 
    state
ORDER BY 
    connection_count DESC;

-- Lock monitoring
SELECT 
    pl.locktype,
    pl.mode,
    pl.granted,
    pa.state,
    pa.query_start,
    pa.query
FROM 
    pg_locks pl
    JOIN pg_stat_activity pa ON pl.pid = pa.pid
WHERE 
    NOT pl.granted
ORDER BY 
    pa.query_start;
