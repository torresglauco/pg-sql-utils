/*
 * PostgreSQL Script: Index Analysis and Optimization
 * Author: Enhanced collection for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive index analysis for performance optimization
 */

-- Index usage statistics and recommendations
SELECT 
    schemaname AS schema_name,
    tablename AS table_name,
    indexname AS index_name,
    idx_tup_read AS index_tuples_read,
    idx_tup_fetch AS index_tuples_fetched,
    idx_blks_read AS index_blocks_read,
    idx_blks_hit AS index_blocks_hit,
    CASE 
        WHEN (idx_blks_read + idx_blks_hit) > 0 
        THEN ROUND((idx_blks_hit * 100.0 / (idx_blks_read + idx_blks_hit)), 2)
        ELSE 0 
    END AS index_cache_hit_ratio,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    pg_relation_size(indexrelid) AS index_bytes,
    CASE 
        WHEN idx_scan = 0 THEN 'UNUSED - Consider dropping'
        WHEN idx_scan < 100 THEN 'LOW USAGE - Review necessity'
        WHEN idx_scan < 1000 THEN 'MODERATE USAGE'
        ELSE 'HIGH USAGE'
    END AS usage_recommendation,
    idx_scan AS scans_count
FROM 
    pg_stat_user_indexes
ORDER BY 
    idx_scan ASC,
    pg_relation_size(indexrelid) DESC;

-- Missing indexes suggestions (tables with sequential scans)
SELECT 
    'MISSING_INDEX_SUGGESTIONS' AS analysis_type,
    schemaname AS schema_name,
    tablename AS table_name,
    seq_scan AS sequential_scans,
    seq_tup_read AS tuples_read_sequentially,
    idx_scan AS index_scans,
    CASE 
        WHEN idx_scan > 0 
        THEN ROUND((seq_scan * 100.0 / (seq_scan + idx_scan)), 2)
        ELSE 100.0 
    END AS sequential_scan_percentage,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS table_size,
    'Consider adding indexes on frequently queried columns' AS recommendation
FROM 
    pg_stat_user_tables
WHERE 
    schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    AND seq_scan > 1000  -- Tables with high sequential scan count
    AND (idx_scan = 0 OR (seq_scan * 100.0 / (seq_scan + idx_scan)) > 50)  -- High seq scan ratio
ORDER BY 
    seq_scan DESC;
