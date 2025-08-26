# PostgreSQL Database Utility Scripts

A comprehensive collection of PostgreSQL utility scripts designed to assist database administrators with monitoring, maintenance, compliance, and migration tasks.

## 🚀 Scripts Overview

### Core Monitoring & Maintenance

#### `vacuum_analyzer.sql`
- **Purpose**: Analyzes table bloat and recommends vacuum schedules
- **Features**: 
  - Identifies tables with high dead tuple ratios
  - Prioritizes vacuum operations (High/Medium/Low priority)
  - Provides size information and maintenance history
- **Usage**: Essential for maintaining optimal database performance

#### `performance_analyzer.sql`
- **Purpose**: Comprehensive performance analysis and optimization recommendations
- **Features**:
  - Top resource-consuming queries analysis
  - Index usage statistics and recommendations
  - Table bloat estimation
  - Connection and lock monitoring
- **Requirements**: `pg_stat_statements` extension recommended

#### `replication_monitor.sql`
- **Purpose**: Monitors PostgreSQL replication status and lag
- **Features**:
  - Server role identification (Primary/Standby)
  - Replication lag analysis with alert levels
  - WAL generation monitoring
  - Replication slots information
- **Use Case**: Critical for high-availability setups

### Migration & Planning

#### `migration_assistant.sql`
- **Purpose**: Pre-migration analysis and cloud readiness assessment
- **Features**:
  - Database size categorization and migration time estimates
  - Extension compatibility analysis for cloud providers
  - Custom objects inventory (types, functions, large objects)
  - Largest tables identification for planning
- **Use Case**: Essential before cloud migrations or major upgrades

### Compliance & Security

#### `compliance_checker.sql`
- **Purpose**: Data privacy compliance assessment (GDPR, LGPD, CCPA)
- **Features**:
  - PII (Personally Identifiable Information) detection
  - Access control analysis
  - Security measures verification
  - Data retention policy review
- **Use Case**: Regulatory compliance and security audits

## 📋 Requirements

- PostgreSQL 12 or higher
- Appropriate database privileges (typically superuser or database owner)
- For performance analysis: `pg_stat_statements` extension

## 🔧 Installation & Usage

### Quick Start

1. Clone this repository:
```bash
git clone <repository-url>
cd postgresql-utility-scripts
```

2. Execute individual scripts:
```bash
psql -f script_name.sql -d your_database_name
```

3. For comprehensive analysis, run all scripts:
```bash
chmod +x run_all_scripts.sh
./run_all_scripts.sh your_database_name
```

### Script-Specific Usage

#### Vacuum Analysis
```bash
psql -f vacuum_analyzer.sql -d production_db > vacuum_report.txt
```

#### Replication Monitoring
```bash
# Run on primary server
psql -f replication_monitor.sql -d production_db
```

#### Migration Assessment
```bash
psql -f migration_assistant.sql -d database_to_migrate > migration_assessment.txt
```

#### Performance Analysis
```bash
# Ensure pg_stat_statements is enabled
psql -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;" -d your_db
psql -f performance_analyzer.sql -d your_db
```

#### Compliance Check
```bash
psql -f compliance_checker.sql -d sensitive_data_db > compliance_report.txt
```

## 📊 Output Examples

### Vacuum Analyzer Output
```
 database_name | schema_name | table_name | dead_row_percentage | vacuum_priority 
--------------+-------------+------------+--------------------+-----------------
 mydb         | public      | user_logs  | 25.40              | HIGH - VACUUM REQUIRED
 mydb         | public      | sessions   | 15.20              | MEDIUM - SCHEDULE VACUUM
```

### Replication Monitor Output
```
 server_role | replica_name | lag_size | lag_status        | sync_state 
-------------+--------------+----------+-------------------+------------
 PRIMARY     | replica-01   | 2456 kB  | NORMAL - Minor lag| async
```

## ⚡ Performance Tips

1. **Regular Monitoring**: Schedule these scripts to run automatically via cron
2. **Baseline Establishment**: Run scripts on healthy systems to establish performance baselines
3. **Alert Integration**: Integrate output with monitoring systems (Nagios, Zabbix, etc.)
4. **Documentation**: Keep results for trend analysis and capacity planning

## 🛡️ Security Considerations

- Review and understand each script before execution
- Test in non-production environments first
- Be cautious with the compliance checker output - it may reveal sensitive data patterns
- Ensure proper access controls are in place when sharing script results

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-script`)
3. Commit your changes (`git commit -am 'Add new monitoring script'`)
4. Push to the branch (`git push origin feature/new-script`)
5. Create a Pull Request

### Contribution Guidelines

- Follow existing code style and documentation standards
- Include appropriate comments and usage examples
- Test scripts on multiple PostgreSQL versions when possible
- Update README.md with new script information

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: Report bugs and request features via GitHub Issues
- **Documentation**: Comprehensive comments within each script
- **Community**: Contributions and improvements welcome

## 📈 Roadmap

- [ ] Add automated alerting capabilities
- [ ] Integrate with popular monitoring tools
- [ ] Add support for PostgreSQL-compatible databases (CockroachDB, etc.)
- [ ] Create Docker-based execution environment
- [ ] Add JSON/XML output formats for integration

---

**Note**: Always test these scripts in a development environment before running in production. While designed to be read-only and safe, database environments can vary significantly.

**Compatibility**: Tested on PostgreSQL 12, 13, 14, 15, and 16.
