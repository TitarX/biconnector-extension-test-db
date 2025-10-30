# Customer Database Management Commands Guide

This document provides a comprehensive guide to all available Make commands for managing the customer database environment with MySQL and PostgreSQL containers.

## Overview

The customer database system includes:
- **MySQL**: Comprehensive customer database with customers, companies, orders, addresses, interactions, and support tickets
- **PostgreSQL**: Advanced customer database with UUID-based architecture, custom types, and JSONB support
- **UTF-8 Encoding**: All data stored in UTF-8 format with English language content
- **Demo Data**: Rich sample data for testing and development

## Quick Start

```bash
# Start databases and populate with demo data
make init

# Access database CLIs
make mysql-cli
make postgres-cli

# View database statistics
make stats
```

## Basic Operations

### Starting and Stopping

| Command | Description | Usage |
|---------|-------------|-------|
| `make up` | Start database containers | Basic startup with 45-second initialization wait |
| `make down` | Stop and remove containers (preserves data) | Safe shutdown maintaining data volumes |
| `make stop` | Stop containers without removing | Quick stop for temporary shutdown |
| `make remove` | Remove stopped containers | Cleanup after stop command |
| `make restart` | Restart containers | Equivalent to down + up |

### Example Usage:
```bash
# Start the databases
make up

# Stop temporarily
make stop

# Remove stopped containers  
make remove

# Full restart
make restart
```

## Database Operations

### Data Management

| Command | Description | Details |
|---------|-------------|---------|
| `make seed-data` | Populate with demo data | Loads comprehensive customer data into both databases |
| `make test-connections` | Test database connectivity | Verifies both MySQL and PostgreSQL connections |
| `make stats` | Show database statistics | Displays record counts for major tables |
| `make backup` | Create database backups | Creates timestamped backup files |
| `make restore` | Restore from backup | Interactive restore with file selection |

### Demo Data Includes:
- **MySQL**: 20 customers with companies, addresses, orders, interactions, support tickets
- **PostgreSQL**: 20 users with companies, segments, communication preferences, orders
- **Comprehensive relationships** between all entities
- **Realistic business data** in English

### Example Usage:
```bash
# Populate databases
make seed-data

# Check data was loaded
make stats

# Create backup before changes
make backup

# Test connectivity
make test-connections
```

## Container Management

### Recreation Commands

| Command | Description | Use Case |
|---------|-------------|----------|
| `make recreate-mysql` | Recreate MySQL container only | MySQL-specific issues |
| `make recreate-postgres` | Recreate PostgreSQL container only | PostgreSQL-specific issues |
| `make recreate-all` | Recreate all containers (with confirmation) | General container refresh |
| `make force-recreate` | Force recreate without confirmation | Automated scripts |

### Maintenance Commands

| Command | Description | Impact |
|---------|-------------|--------|
| `make clean` | Full cleanup - removes containers and volumes | ⚠️ **DATA LOSS** - Removes all data |
| `make rebuild` | Rebuild from scratch | ⚠️ **DATA LOSS** - Complete rebuild |
| `make init` | Full initialization | Fresh start with demo data |

### Example Usage:
```bash
# Recreate MySQL container if having issues
make recreate-mysql

# Full refresh with confirmation
make recreate-all

# Nuclear option - complete rebuild
make rebuild
```

## Database Access

### CLI Access

| Command | Description | Connection Details |
|---------|-------------|-------------------|
| `make mysql-cli` | Connect to MySQL CLI | Direct access to customer_db |
| `make postgres-cli` | Connect to PostgreSQL CLI | Direct access to customer_db |

### Connection Information:
- **MySQL**: `localhost:3306` (user: testuser, pass: testpass123, db: customer_db)
- **PostgreSQL**: `localhost:5432` (user: testuser, pass: testpass123, db: customer_db)

### Example CLI Usage:
```bash
# Connect to MySQL
make mysql-cli
# Then run: SHOW TABLES; SELECT COUNT(*) FROM customers;

# Connect to PostgreSQL  
make postgres-cli
# Then run: \dt; SELECT COUNT(*) FROM customers;
```

## Monitoring and Debugging

### Status Commands

| Command | Description | Information Provided |
|---------|-------------|---------------------|
| `make status` | Container status | Running containers and volumes |
| `make logs` | Container logs | Real-time log streaming |

### Example Usage:
```bash
# Check what's running
make status

# Monitor logs (Ctrl+C to exit)
make logs
```

## Backup and Restore

### Backup System

The backup system creates timestamped SQL dump files:

```bash
# Create backups
make backup

# Files created in backups/ directory:
# - mysql_customer_backup_2024-10-30_14-30-45.sql
# - postgres_customer_backup_2024-10-30_14-30-45.sql
```

### Manual Restore Examples:

```bash
# Restore MySQL backup
docker exec -i test_mysql_db mysql -u testuser -ptestpass123 customer_db < backups/mysql_backup_file.sql

# Restore PostgreSQL backup
docker cp backups/postgres_backup_file.sql test_postgres_db:/tmp/
docker exec test_postgres_db psql -U testuser -d customer_db -f /tmp/postgres_backup_file.sql
```

## Database Schema

### MySQL Tables:
- `customers` - Main customer information
- `companies` - Business information
- `customer_companies` - Customer-company relationships
- `addresses` - Customer addresses
- `communication_preferences` - Contact preferences
- `customer_segments` - Customer categorization
- `customer_segment_assignments` - Segment assignments
- `orders` - Transaction history
- `customer_interactions` - Activity log
- `support_tickets` - Support ticket system

### PostgreSQL Tables:
Similar structure with:
- UUID-based primary keys
- Custom PostgreSQL data types
- JSONB fields for flexible data
- Advanced indexing
- Automatic timestamp triggers

## Troubleshooting

### Common Issues and Solutions:

1. **Containers won't start**:
   ```bash
   make clean
   make up
   ```

2. **Database connection issues**:
   ```bash
   make test-connections
   make logs
   ```

3. **Data corruption**:
   ```bash
   make backup  # If possible
   make clean
   make init
   ```

4. **Port conflicts**:
   - Check docker-compose.yml ports (3306, 5432)
   - Stop conflicting services

### Performance Optimization:

1. **Monitor resource usage**:
   ```bash
   docker stats test_mysql_db test_postgres_db
   ```

2. **Database optimization**:
   - Both databases include proper indexing
   - Regular statistics updates recommended

## Best Practices

### Development Workflow:
1. Start with `make init` for fresh environment
2. Use `make backup` before major changes
3. Regular `make stats` to monitor data growth
4. Use `make test-connections` to verify health

### Production Considerations:
- Regular backups with `make backup`
- Monitor logs with `make logs`
- Use `make status` for health checks
- Consider volume snapshots for disaster recovery

## Command Reference Summary

```bash
# Essential commands
make help              # Show all commands
make init              # Fresh start with data
make up                # Start containers
make down              # Stop containers
make seed-data         # Load demo data
make stats             # Show data statistics

# Database access
make mysql-cli         # MySQL command line
make postgres-cli      # PostgreSQL command line
make test-connections  # Test connectivity

# Maintenance
make backup            # Create backups
make clean             # Full cleanup (data loss!)
make rebuild           # Rebuild everything
make logs              # Monitor logs
make status            # Check container status
```

## Support

For issues or questions:
1. Check container logs: `make logs`
2. Verify status: `make status`
3. Test connections: `make test-connections`
4. Try recreation: `make recreate-all`

---

**Note**: Commands marked with ⚠️ will result in data loss. Always backup important data before using destructive commands.
