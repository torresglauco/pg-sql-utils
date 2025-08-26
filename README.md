# PostgreSQL Database Utility Scripts - Enhanced Edition

A comprehensive, enterprise-grade collection of PostgreSQL utility scripts with advanced monitoring, alerting, and multi-format output capabilities.

## 🚀 Enhanced Features

### 🔔 **Automated Alerting System**
- Email, Slack, and PagerDuty integration
- Configurable thresholds and cooldown periods
- Smart alert correlation and deduplication

### 📊 **Multi-Platform Monitoring Integration**
- **Prometheus/Grafana**: Custom metrics exporter with pre-built dashboards
- **Nagios**: Production-ready monitoring plugins
- **Zabbix**: Complete template with triggers and graphs

### 🔄 **Multi-Database Compatibility**
- **PostgreSQL**: Full feature support
- **CockroachDB**: Adapted for distributed SQL
- **YugabyteDB**: Cloud-native PostgreSQL compatibility
- **Amazon Aurora**: AWS-optimized monitoring

### 🐳 **Docker-Based Execution Environment**
- Complete containerized monitoring stack
- Docker Compose with Prometheus, Grafana, and PostgreSQL
- Web interface for easy management
- Automated deployment and scaling

### 📤 **Multiple Output Formats**
- **JSON**: For REST APIs and modern integrations
- **XML**: Enterprise system compatibility
- **CSV**: Spreadsheet and reporting tools
- **YAML**: Configuration management systems

## 📋 Quick Start

### Docker Deployment (Recommended)
```bash
# Clone and build
git clone <repository-url>
cd postgresql-utility-scripts
chmod +x docker/build_docker.sh
./docker/build_docker.sh

# Full stack deployment
docker-compose up -d

# Access points:
# - Web Interface: http://localhost:8080
# - Prometheus: http://localhost:9090
# - Grafana: http://localhost:3000 (admin/admin)
```

### Traditional Installation
```bash
# Install dependencies
pip install -r requirements.txt

# Run individual scripts
psql -f scripts/vacuum_analyzer.sql -d your_database

# Run with specific output format
python3 output/output_formatter.py --format json --queries vacuum_analysis replication_status
```

## 🔧 Advanced Configuration

### Alerting Setup
```bash
# Configure alerts
cp monitoring/alert_config.conf.example monitoring/alert_config.conf
# Edit thresholds and notification channels
nano monitoring/alert_config.conf

# Start alert monitoring
./monitoring/alert_monitor.sh
```

### API Server
```bash
# Start REST API server
export POSTGRES_HOST=localhost
export POSTGRES_DB=your_database
python3 api/api_server.py

# API endpoints available at http://localhost:5000
```

### Multi-Database Support
```bash
# Detect database type and adapt scripts
python3 compatibility/database_compatibility.py --host cockroachdb.example.com --output json

# Run adaptive analysis
./compatibility/adaptive_runner.sh cockroachdb.example.com 26257 defaultdb root
```

## 📊 Monitoring Integrations

### Prometheus Metrics
```bash
# Start metrics exporter
python3 monitoring/prometheus_exporter.py \
    --host localhost --database postgres \
    --metrics-port 9187
```

### Nagios Integration
```bash
# Check vacuum status
./monitoring/nagios_plugin.sh -H localhost -d postgres -t vacuum_needed -w 5 -c 10

# Check replication lag
./monitoring/nagios_plugin.sh -H localhost -d postgres -t replication_lag -w 100 -c 500
```

## 🔄 Output Format Examples

### JSON Output
```json
{
  "metadata": {
    "timestamp": "2024-01-01T12:00:00",
    "format": "json"
  },
  "results": [
    {
      "query_name": "vacuum_analysis",
      "data": [
        {
          "schema_name": "public",
          "table_name": "users",
          "dead_row_percentage": 25.4,
          "vacuum_priority": "HIGH - VACUUM REQUIRED"
        }
      ]
    }
  ]
}
```

### API Usage
```bash
# Get vacuum status as JSON
curl http://localhost:5000/vacuum

# Get replication status as XML
curl http://localhost:5000/replication/xml

# Execute custom query
curl -X POST http://localhost:5000/custom \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT version()", "format": "json"}'
```

## 🛡️ Security & Compliance

- **Data Privacy**: Built-in PII detection for GDPR/LGPD/CCPA compliance
- **Access Control**: Role-based monitoring with privilege checks
- **Audit Trail**: Complete logging of all monitoring activities
- **Encryption**: SSL/TLS support for all connections

## 📈 Performance & Scalability

- **Lightweight**: Minimal resource footprint
- **Concurrent**: Parallel query execution support
- **Caching**: Intelligent result caching for frequent queries
- **Batching**: Efficient bulk operations for large datasets

## 🤝 Enterprise Features

### High Availability
- **Failover**: Automatic failover to standby databases
- **Load Balancing**: Connection pooling and load distribution
- **Clustering**: Multi-node monitoring support

### Integration APIs
- **REST API**: RESTful endpoints for all monitoring functions
- **GraphQL**: Advanced query capabilities
- **Webhooks**: Event-driven notifications

### Compliance & Auditing
- **SOX Compliance**: Financial reporting requirements
- **HIPAA**: Healthcare data protection
- **ISO 27001**: Information security management

## 📝 Documentation

### Core Scripts
- **vacuum_analyzer.sql**: Identifies tables needing vacuum maintenance
- **replication_monitor.sql**: Monitors replication lag and status
- **performance_analyzer.sql**: Analyzes query performance and index usage
- **migration_assistant.sql**: Assesses migration readiness and compatibility
- **compliance_checker.sql**: Scans for PII and compliance issues

### Monitoring Tools
- **prometheus_exporter.py**: Exports PostgreSQL metrics to Prometheus
- **nagios_plugin.sh**: Nagios-compatible monitoring checks
- **alert_monitor.sh**: Automated alerting system

### Output Formatters
- **output_formatter.py**: Converts query results to JSON/XML/CSV/YAML
- **api_server.py**: REST API for programmatic access

### Multi-Database Support
- **database_compatibility.py**: Detects and adapts to different database types
- **adaptive_runner.sh**: Automatically runs appropriate scripts based on database type

## 🔧 Development

```bash
# Development setup
git clone <repository-url>
cd postgresql-utility-scripts
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run individual scripts
psql -f scripts/vacuum_analyzer.sql -d testdb

# Start full monitoring stack
docker-compose up -d
```

## 📞 Support

- **Documentation**: Comprehensive inline documentation
- **Examples**: Real-world usage examples in docs/
- **Community**: GitHub Issues and Discussions
- **Enterprise**: Professional support available

---

**Compatibility**: PostgreSQL 12+, CockroachDB 20+, YugabyteDB 2.8+, Aurora PostgreSQL  
**License**: MIT License  
**Maintained by**: Database Enhancement Scripts Team
