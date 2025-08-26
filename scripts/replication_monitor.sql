/*
 * PostgreSQL Script: Replication Monitoring
 * Author: Database Enhancement Scripts
 * Compatible with: PostgreSQL 12+
 * Description: Comprehensive replication monitoring for PostgreSQL clusters
 * Usage: psql -f replication_monitor.sql -d your_database
 */

-- Check server role
SELECT 
    CASE 
        WHEN pg_is_in_recovery() THEN 'STANDBY/REPLICA'
        ELSE 'PRIMARY/MASTER'
    END AS server_role,
    current_database() AS database_name,
    version() AS postgresql_version;

-- Primary server: Check replication status and lag
SELECT 
    application_name AS replica_name,
    client_addr AS replica_ip,
    client_port AS replica_port,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS lag_bytes,
    pg_size_pretty(pg_wal_lsn_diff(sent_lsn, replay_lsn)) AS lag_size,
    CASE 
        WHEN pg_wal_lsn_diff(sent_lsn, replay_lsn) > 1073741824 THEN 'CRITICAL - Over 1GB lag'
        WHEN pg_wal_lsn_diff(sent_lsn, replay_lsn) > 104857600 THEN 'WARNING - Over 100MB lag'
        WHEN pg_wal_lsn_diff(sent_lsn, replay_lsn) > 10485760 THEN 'ATTENTION - Over 10MB lag'
        WHEN pg_wal_lsn_diff(sent_lsn, replay_lsn) > 0 THEN 'NORMAL - Minor lag'
        ELSE 'EXCELLENT - No lag'
    END AS lag_status,
    sync_state,
    sync_priority,
    backend_start,
    backend_xmin
FROM 
    pg_stat_replication
ORDER BY
    pg_wal_lsn_diff(sent_lsn, replay_lsn) DESC;

-- WAL generation rate (useful for capacity planning)
SELECT
    current_timestamp AS check_time,
    pg_current_wal_lsn() AS current_wal_lsn,
    pg_walfile_name(pg_current_wal_lsn()) AS current_wal_file;

-- Replication slots information
SELECT
    slot_name,
    plugin,
    slot_type,
    datoid,
    database,
    temporary,
    active,
    active_pid,
    xmin,
    catalog_xmin,
    restart_lsn,
    confirmed_flush_lsn,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS slot_lag_size
FROM
    pg_replication_slots
ORDER BY
    pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn) DESC;
