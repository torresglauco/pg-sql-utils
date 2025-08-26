# PostgreSQL Database Administration Scripts

A comprehensive collection of PostgreSQL administration and monitoring scripts designed for database administrators, developers, and DevOps engineers.

## 📋 Overview

This repository contains enhanced PostgreSQL scripts that help with database administration, performance monitoring, security auditing, and optimization tasks. All scripts are compatible with PostgreSQL 12+ and include detailed documentation and best practices.

## 🚀 Scripts Included

### Core Administration Scripts

#### 1. `find_procedure_with_name.sql`
**Purpose**: Search for stored procedures and functions by name pattern
- Find procedures/functions by exact or partial name match
- Display comprehensive information including arguments, type, owner, and language
- Show estimated cost and source code size
- Compatible with all PostgreSQL function types (functions, procedures, aggregates, window functions)

**Usage**:
```sql
-- Edit the script and replace 'your_pattern' with your search term
-- Example: WHERE p.proname ILIKE '%user%'
```

#### 2. `find_procedure_with_part_procedure.sql`
**Purpose**: Advanced search for procedures by name or content
- Search by partial procedure name
- Search within procedure source code
- Multiple search options with detailed results

**Usage**:
```sql
-- Replace 'partial_name' with name pattern
-- Replace 'search_text' with text to find in source code
```

#### 3. `find_table_with_field.sql`
**Purpose**: Locate tables containing specific column names
- Comprehensive column information including data types
- Primary key and foreign key relationship detection
- Table size information
- Support for pattern matching on column names

**Usage**:
```sql
-- Replace 'your_column_name' with the column you're searching for
-- Supports ILIKE patterns like '%user%', 'id', etc.
```

#### 4. `size_database.sql`
**Purpose**: Comprehensive database size analysis
- Database overview with total size
- Breakdown by schemas
- Database growth and performance statistics
- Connection and activity summary
- Cache hit ratios and transaction statistics

#### 5. `size_tables.sql`
**Purpose**: Detailed table size analysis
- Complete table size breakdown (table, indexes)
- Row statistics and activity metrics
- Maintenance information (vacuum, analyze history)
- Schema summaries and top tables by size

#### 6. `where_trigger_enabled.sql`
**Purpose**: Comprehensive trigger analysis and management
- Complete trigger information with status
- Trigger function analysis
- Tables with multiple triggers
- Disabled trigger identification

### Advanced Monitoring Scripts

#### 7. `index_analysis.sql`
**Purpose**: Index optimization and performance analysis
- Index usage statistics and recommendations
- Missing index suggestions
- Index maintenance guidelines

#### 8. `performance_monitoring.sql`
**Purpose**: Real-time performance monitoring dashboard
- Database performance overview
- Lock analysis and blocking queries
- Connection and session monitoring
- Table performance statistics

#### 9. `security_audit.sql`
**Purpose**: Security audit and compliance checking
- User and role privilege analysis
- Sensitive table identification
- Function security analysis
- Security risk assessment

## 🛠️ Installation and Setup

### Prerequisites
- PostgreSQL 12 or higher
- Appropriate database permissions for monitoring queries

### Basic Setup
1. Clone this repository:
```bash
git clone https://github.com/torresglauco/sql.git
cd sql
```

2. Connect to your PostgreSQL database:
```bash
psql -h localhost -U your_username -d your_database
```

3. Run any script:
```sql
\i find_procedure_with_name.sql
```

## 📖 Usage Guidelines

### General Usage
1. **Edit before running**: Most scripts contain placeholder values (like 'your_pattern') that need to be replaced
2. **Review permissions**: Ensure you have appropriate permissions for the operations
3. **Test on development**: Always test scripts on development environments first
4. **Understand output**: Review the script comments to understand what each column means

### Performance Considerations
- Large databases may take longer to execute size analysis scripts
- Performance monitoring scripts may impact performance on busy systems
- Consider running during maintenance windows for comprehensive analysis

### Security Considerations
- Security audit scripts require elevated privileges
- Review security recommendations carefully before implementing changes
- Some scripts may expose sensitive information - use appropriate access controls

## 🔧 Customization

### Modifying Search Patterns
Most scripts use PostgreSQL's ILIKE operator for pattern matching:
- `%text%` - Contains 'text' anywhere
- `text%` - Starts with 'text'
- `%text` - Ends with 'text'
- `text` - Exact match (case insensitive)

### Adding Custom Filters
You can enhance scripts with additional WHERE clauses:
```sql
-- Example: Filter by schema
AND schemaname = 'public'

-- Example: Filter by size
AND pg_total_relation_size(schemaname||'.'||tablename) > 1048576  -- > 1MB

-- Example: Filter by activity
AND n_live_tup > 1000  -- Tables with more than 1000 rows
```

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-script`)
3. Commit your changes (`git commit -m 'Add amazing new script'`)
4. Push to the branch (`git push origin feature/amazing-script`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style and commenting patterns
- Include comprehensive comments explaining the script's purpose
- Test scripts on multiple PostgreSQL versions when possible
- Update this README if adding new scripts

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Original scripts inspired by PostgreSQL community best practices
- Enhanced for modern PostgreSQL versions (12+)
- Community feedback and contributions

## 📞 Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Check existing issues for similar problems
- Contribute improvements via pull requests

## 🔄 Version History

### v2.0.0 (Current)
- Complete rewrite with PostgreSQL 12+ compatibility
- Added comprehensive commenting and documentation
- Introduced new scripts for index analysis, performance monitoring, and security auditing
- Improved error handling and edge cases
- Enhanced output formatting and readability

### v1.0.0 (Original)
- Basic PostgreSQL administration scripts
- Core functionality for procedure, table, and size analysis

---

**Made with ❤️ for the PostgreSQL community**
