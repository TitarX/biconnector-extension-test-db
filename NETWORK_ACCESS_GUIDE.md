# Network Access Guide for Database Containers

This guide explains how to connect to the MySQL and PostgreSQL databases from other Docker containers running on the same host.

## Quick Setup

1. **Start the databases** (this automatically creates the shared network):
   ```bash
   make start
   ```

2. **Connect your container** to the shared network using one of the methods below.

## Connection Methods

### Method 1: Run existing container on shared network
```bash
# Connect running container to shared network
docker network connect shared_db_network your_container_name

# Or run new container with network
docker run --network shared_db_network your_image
```

### Method 2: Docker Compose configuration
Add this to your docker-compose.yml:
```yaml
version: '3.8'
services:
  your_app:
    image: your_app_image
    networks:
      - shared_db_network
    # your other configuration...

networks:
  shared_db_network:
    external: true
    name: shared_db_network
```

### Method 3: Use host networking (alternative)
```bash
# Run container with host network access
docker run --network host your_image
# Access databases via localhost:3306 and localhost:5432
```

## Database Connection Details

### From containers on shared_db_network:
- **MySQL**: 
  - Host: `mysql`
  - Port: `3306`
  - Database: `customer_db`
  - User: `testuser`
  - Password: `testpass123`

- **PostgreSQL**:
  - Host: `postgres` 
  - Port: `5432`
  - Database: `customer_db`
  - User: `testuser`
  - Password: `testpass123`

### Connection Strings:
```bash
# MySQL
mysql://testuser:testpass123@mysql:3306/customer_db

# PostgreSQL
postgresql://testuser:testpass123@postgres:5432/customer_db
```

## Testing Connection

### From inside your container:
```bash
# Test MySQL connection
mysql -h mysql -u testuser -ptestpass123 customer_db -e "SELECT VERSION();"

# Test PostgreSQL connection  
psql -h postgres -U testuser -d customer_db -c "SELECT version();"

# Test network connectivity
ping mysql
ping postgres
```

### From command line:
```bash
# Check network status
make network-info

# Test database connections
make test-connections
```

## Common Programming Examples

### PHP (mysqli)
```php
$mysqli = new mysqli("mysql", "testuser", "testpass123", "customer_db");
if ($mysqli->connect_error) {
    die('Connect Error: ' . $mysqli->connect_error);
}
```

### PHP (PDO - MySQL)
```php
$pdo = new PDO("mysql:host=mysql;dbname=customer_db", "testuser", "testpass123");
```

### PHP (PDO - PostgreSQL)
```php
$pdo = new PDO("pgsql:host=postgres;dbname=customer_db", "testuser", "testpass123");
```

### Node.js (MySQL)
```javascript
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'mysql',
  user: 'testuser',
  password: 'testpass123',
  database: 'customer_db'
});
```

### Node.js (PostgreSQL)
```javascript
const { Client } = require('pg');
const client = new Client({
  host: 'postgres',
  user: 'testuser',
  password: 'testpass123',
  database: 'customer_db',
  port: 5432,
});
```

### Python (MySQL)
```python
import mysql.connector
conn = mysql.connector.connect(
    host='mysql',
    user='testuser', 
    password='testpass123',
    database='customer_db'
)
```

### Python (PostgreSQL)
```python
import psycopg2
conn = psycopg2.connect(
    host="postgres",
    database="customer_db", 
    user="testuser",
    password="testpass123"
)
```

## Troubleshooting

### Network Issues:
```bash
# Check if shared network exists
docker network ls | grep shared_db_network

# Create network manually if needed
make create-network

# Check database containers are running
make status

# Inspect network details
docker network inspect shared_db_network
```

### Connection Issues:
```bash
# Check if your container is on the network
docker inspect your_container_name | grep NetworkMode

# Test from database containers
make shell-mysql
# Inside: ping your_container_name

make shell-postgres  
# Inside: ping your_container_name
```

### Database Access Issues:
```bash
# Verify databases are accessible
make test-connections

# Check database logs
make logs

# Try direct connection from host
make mysql-cli
make postgres-cli
```

## Network Management Commands

```bash
# Create shared network (auto-done with make start)
make create-network

# Show network information and connection examples
make network-info

# Remove network (stops containers first)  
make remove-network

# Start databases with network setup
make start

# Check overall status
make status
```

---

**Note**: The shared network `shared_db_network` is automatically created when you run `make start`. Other containers can then connect to this network to access the databases using the service names `mysql` and `postgres`.
