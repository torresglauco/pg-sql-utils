/*
 * PostgreSQL Script: Database Size Analysis
 * Author: Enhanced version for torresglauco/sql repository
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive database size analysis with detailed breakdown
 */

-- Overview: Current database size
SELECT 
    current_database() AS database_name,
    pg_size_pretty(pg_database_size(current_database())) AS total_size,
    pg_database_size(current_database()) AS size_bytes;

-- Detailed breakdown by database components
WITH database_stats AS (
    SELECT 
        current_database() AS db_name,
        pg_database_size(current_database()) AS total_size
),
schema_stats AS (
    SELECT 
        schemaname AS schema_name,
        SUM(pg_total_relation_size(schemaname||'.'||tablename)) AS schema_size
    FROM 
        pg_tables
    WHERE 
        schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    GROUP BY 
        schemaname
)
SELECT 
    'DATABASE_OVERVIEW' AS component_type,
    db_name AS name,
    pg_size_pretty(total_size) AS size,
    total_size AS size_bytes,
    100.0 AS percentage
FROM 
    database_stats

UNION ALL

SELECT 
    'SCHEMA' AS component_type,
    schema_name AS name,
    pg_size_pretty(schema_size) AS size,
    schema_size AS size_bytes,
    ROUND((schema_size * 100.0 / (SELECT total_size FROM database_stats)), 2) AS percentage
FROM 
    schema_stats
WHERE 
    schema_size > 0

ORDER BY 
    component_type,
    size_bytes DESC;

-- Database growth analysis (requires pg_stat_database)
SELECT 
    datname AS database_name,
    numbackends AS active_connections,
    xact_commit AS transactions_committed,
    xact_rollback AS transactions_rolled_back,
    blks_read AS blocks_read,
    blks_hit AS blocks_hit,
    CASE 
        WHEN (blks_read + blks_hit) > 0 
        THEN ROUND((blks_hit * 100.0 / (blks_read + blks_hit)), 2)
        ELSE 0 
    END AS cache_hit_ratio,
    tup_returned AS tuples_returned,
    tup_fetched AS tuples_fetched,
    tup_inserted AS tuples_inserted,
    tup_updated AS tuples_updated,
    tup_deleted AS tuples_deleted,
    conflicts AS conflicts,
    temp_files AS temporary_files,
    pg_size_pretty(temp_bytes) AS temporary_bytes,
    deadlocks,
    stats_reset AS statistics_reset_time
FROM 
    pg_stat_database 
WHERE 
    datname = current_database();
