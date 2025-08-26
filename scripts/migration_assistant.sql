/*
 * PostgreSQL Script: Cloud Migration Assessment
 * Author: Database Enhancement Scripts
 * Compatible with: PostgreSQL 12+
 * Description: Pre-migration analysis and cloud readiness assessment
 * Usage: psql -f migration_assistant.sql -d your_database
 */

-- Database size assessment for migration planning
SELECT 
    current_database() AS database_name,
    pg_size_pretty(pg_database_size(current_database())) AS database_size,
    pg_database_size(current_database()) AS size_bytes,
    CASE 
        WHEN pg_database_size(current_database()) > 1099511627776 THEN 'VERY LARGE (>1TB) - Consider logical replication or parallel methods'
        WHEN pg_database_size(current_database()) > 107374182400 THEN 'LARGE (>100GB) - Standard migration tools with extended time'
        WHEN pg_database_size(current_database()) > 10737418240 THEN 'MEDIUM (>10GB) - Standard migration tools'
        ELSE 'SMALL (<10GB) - Quick migration possible'
    END AS migration_size_category,
    CASE 
        WHEN pg_database_size(current_database()) > 1099511627776 THEN '12-48 hours'
        WHEN pg_database_size(current_database()) > 107374182400 THEN '4-12 hours'
        WHEN pg_database_size(current_database()) > 10737418240 THEN '1-4 hours'
        ELSE '< 1 hour'
    END AS estimated_migration_time;

-- Extensions inventory (cloud compatibility check)
SELECT 
    extname AS extension_name,
    extversion AS extension_version,
    nspname AS schema_name,
    CASE 
        WHEN extname IN ('pg_stat_statements', 'pgcrypto', 'uuid-ossp', 'btree_gin', 'btree_gist') THEN 'WIDELY SUPPORTED'
        WHEN extname IN ('PostGIS', 'pg_trgm', 'fuzzystrmatch', 'unaccent') THEN 'COMMONLY SUPPORTED'
        ELSE 'VERIFY CLOUD PROVIDER SUPPORT'
    END AS cloud_compatibility
FROM 
    pg_extension e
    JOIN pg_namespace n ON e.extnamespace = n.oid
ORDER BY 
    cloud_compatibility, extname;

-- Custom objects that may require special attention
SELECT 
    'CUSTOM TYPES' AS object_category,
    COUNT(*) AS object_count,
    'Review custom types for cloud compatibility' AS migration_notes
FROM 
    pg_type t 
    JOIN pg_namespace n ON t.typnamespace = n.oid 
WHERE 
    n.nspname NOT IN ('pg_catalog', 'information_schema')
    AND t.typtype = 'c'

UNION ALL

SELECT 
    'STORED PROCEDURES/FUNCTIONS' AS object_category,
    COUNT(*) AS object_count,
    'Test all functions after migration' AS migration_notes
FROM 
    pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE 
    n.nspname NOT IN ('pg_catalog', 'information_schema')

UNION ALL

SELECT 
    'LARGE OBJECTS' AS object_category,
    COUNT(*) AS object_count,
    'May require special handling - consider converting to bytea' AS migration_notes
FROM 
    pg_largeobject_metadata

UNION ALL

SELECT 
    'FOREIGN TABLES' AS object_category,
    COUNT(*) AS object_count,
    'Verify foreign data wrapper support in target environment' AS migration_notes
FROM 
    information_schema.foreign_tables;

-- Table sizes for migration planning
SELECT 
    schemaname AS schema_name,
    tablename AS table_name,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    pg_total_relation_size(schemaname||'.'||tablename) AS total_bytes
FROM 
    pg_tables 
WHERE 
    schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 20;
