# PostgreSQL Utilities (pg-sql-utils)

## 🚀 Overview

**pg-sql-utils** is a comprehensive collection of enterprise-grade PostgreSQL utility scripts designed to help database administrators monitor, analyze, and maintain PostgreSQL databases efficiently. This toolkit provides powerful scripts for performance analysis, security auditing, compliance checking, and database maintenance.

## ✨ Features

- **🔍 Performance Analysis**: Advanced query performance monitoring and optimization recommendations
- **📊 Database Monitoring**: Real-time monitoring of database metrics, replication, and system health
- **🛡️ Security Auditing**: Comprehensive security assessment and vulnerability detection
- **📋 Compliance Checking**: GDPR, HIPAA, and other regulatory compliance validation
- **🔧 Maintenance Tools**: Automated vacuum analysis and database optimization suggestions
- **📈 Size Analysis**: Database and table size monitoring with growth tracking
- **🔎 Search Utilities**: Advanced search capabilities for procedures, tables, and fields
- **⚡ Index Analysis**: Index usage analysis and optimization recommendations

## 📁 Repository Structure

```
pg-sql-utils/
├── LICENSE                              # MIT License
├── README.md                           # This documentation
├── requirements.txt                    # Python dependencies
├── run_all_scripts.sh                  # Main execution script
├── scripts/                            # Additional utility scripts
│
├── SQL Scripts:
├── compliance_checker.sql              # Data compliance validation
├── find_procedure_with_name.sql        # Search procedures by name
├── find_procedure_with_part_procedure.sql  # Search procedures by partial name
├── find_table_with_field.sql           # Find tables containing specific fields
├── index_analysis.sql                  # Index usage and performance analysis
├── migration_assistant.sql             # Database migration readiness assessment
├── performance_analyzer.sql            # Comprehensive performance analysis
├── performance_monitoring.sql          # Real-time performance monitoring
├── replication_monitor.sql             # Replication lag and status monitoring
├── security_audit.sql                  # Security vulnerability assessment
├── size_database.sql                   # Database size analysis
├── size_tables.sql                     # Table size analysis with recommendations
├── vacuum_analyzer.sql                 # Vacuum maintenance recommendations
└── where_trigger_enabled.sql           # Active trigger identification
```

## 🛠️ Installation

### Prerequisites

- PostgreSQL 9.6 or higher
- `psql` command-line tool
- Bash shell (for running shell scripts)
- Python 3.7+ (for optional features)

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/torresglauco/pg-sql-utils.git
   cd pg-sql-utils
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x run_all_scripts.sh
   ```

3. **Install Python dependencies (optional):**
   ```bash
   pip install -r requirements.txt
   ```

## 🚀 Usage

### Running All Scripts

Execute all utility scripts against your database:

```bash
# Use default 'postgres' database
./run_all_scripts.sh

# Specify a custom database
./run_all_scripts.sh my_database_name
```

The script will create a `reports/` directory with timestamped output files for each analysis.

### Running Individual Scripts

Execute specific analyses:

```bash
# Performance analysis
psql -f performance_analyzer.sql -d your_database

# Security audit
psql -f security_audit.sql -d your_database

# Vacuum analysis
psql -f vacuum_analyzer.sql -d your_database

# Compliance check
psql -f compliance_checker.sql -d your_database
```

## 📊 Script Descriptions

### Performance & Monitoring

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `performance_analyzer.sql` | Comprehensive performance analysis | Query performance, index usage, table bloat, connection monitoring, lock analysis |
| `performance_monitoring.sql` | Real-time performance monitoring | Active queries, resource usage, wait events |
| `replication_monitor.sql` | Replication status monitoring | Lag detection, replica health, sync status |
| `index_analysis.sql` | Index optimization analysis | Usage statistics, redundant indexes, recommendations |

### Maintenance & Optimization

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `vacuum_analyzer.sql` | Vacuum maintenance recommendations | Dead tuple analysis, bloat detection, maintenance scheduling |
| `size_database.sql` | Database size analysis | Total size, growth trends, space utilization |
| `size_tables.sql` | Table size analysis | Individual table sizes, index sizes, growth patterns |
| `migration_assistant.sql` | Migration readiness assessment | Compatibility checks, migration planning, risk assessment |

### Security & Compliance

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `security_audit.sql` | Security vulnerability assessment | Permission analysis, weak passwords, configuration review |
| `compliance_checker.sql` | Data compliance validation | PII detection, GDPR compliance, data sensitivity analysis |

### Search & Discovery

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `find_procedure_with_name.sql` | Find procedures by exact name | Procedure discovery, definition retrieval |
| `find_procedure_with_part_procedure.sql` | Find procedures by partial name | Fuzzy search, pattern matching |
| `find_table_with_field.sql` | Find tables containing specific fields | Column search, data type analysis |
| `where_trigger_enabled.sql` | Find active triggers | Trigger inventory, status monitoring |

## 📋 Sample Output

### Performance Analyzer Results

```
TOP RESOURCE-CONSUMING QUERIES
==============================================
Query: SELECT * FROM large_table WHERE created_at > ...
Calls: 1,245
Total Time: 15,678ms
Mean Time: 12.59ms
Performance Status: MEDIUM - Consider optimization

INDEX USAGE ANALYSIS
==============================================
Schema: public
Table: users
Index: idx_users_email
Reads: 145,678
Status: ACTIVE - Keep index

TABLE BLOAT ANALYSIS
==============================================
Table: public.orders
Bloat Percentage: 25.67%
Status: HIGH BLOAT - Vacuum recommended
```

### Security Audit Results

```
SECURITY ASSESSMENT SUMMARY
==============================================
✓ Password policies enforced
⚠ 3 users with excessive privileges
✗ 2 unencrypted connections detected
⚠ 1 table with public access
```

## 🔧 Configuration

### Environment Variables

```bash
# Database connection settings
export PGHOST=localhost
export PGPORT=5432
export PGUSER=your_username
export PGPASSWORD=your_password
export PGDATABASE=your_database
```

### Script Customization

Most scripts can be customized by modifying the SQL parameters at the top of each file:

```sql
-- Example: Adjust performance thresholds
SET statement_timeout = '30s';
SET work_mem = '256MB';
```

## 📈 Advanced Features

### Automated Monitoring

Set up cron jobs for regular monitoring:

```bash
# Add to crontab for daily reports
0 2 * * * /path/to/pg-sql-utils/run_all_scripts.sh production_db
```

### Integration with Monitoring Systems

The scripts can be integrated with:
- **Prometheus**: Export metrics for monitoring
- **Grafana**: Create dashboards from script outputs
- **Nagios**: Set up alerts based on script results
- **Custom tools**: Parse JSON/CSV outputs programmatically

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-script`
3. Commit your changes: `git commit -am 'Add new utility script'`
4. Push to the branch: `git push origin feature/new-script`
5. Submit a Pull Request

### Contribution Guidelines

- Follow PostgreSQL best practices
- Include comprehensive comments in SQL scripts
- Test scripts on multiple PostgreSQL versions
- Update documentation for new features
- Add example outputs for new scripts

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Getting Help

- **Issues**: Report bugs or request features on [GitHub Issues](https://github.com/torresglauco/pg-sql-utils/issues)
- **Documentation**: Check the script comments for detailed usage instructions
- **Community**: Join discussions and share experiences

### Known Limitations

- Requires `pg_stat_statements` extension for detailed query analysis
- Some scripts may require elevated privileges
- Performance impact should be considered for large databases
- Always test in non-production environments first

## 🔄 Version History

- **Latest**: Enhanced performance monitoring and security auditing
- **Previous**: Added compliance checking and migration assistance
- **Initial**: Basic performance and maintenance scripts

## 🎯 Roadmap

- [ ] Docker containerization
- [ ] REST API interface
- [ ] Multi-database support
- [ ] Enhanced reporting formats
- [ ] Automated alerting system
- [ ] Web-based dashboard

---

**Note**: Always test these scripts in a development environment before running in production. Some scripts may have performance implications on large databases.
