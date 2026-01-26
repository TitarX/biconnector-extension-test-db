# Makefile для управления тестовыми базами данных
# Проект: Test Databases (MySQL + PostgreSQL)

.PHONY: help start down stop remove restart logs status seed-data clean rebuild init recreate-mysql recreate-postgres recreate-all force-recreate test-connections backup restore stats mysql-cli postgres-cli shell-mysql shell-postgres create-network remove-network network-info fix-network

# Default target - show help
all: help

# Show available commands
help:
	@echo "=== Customer Database Management Commands ==="
	@echo ""
	@echo "Basic Operations:"
	@echo "  make help              - Show this help menu"
	@echo "  make start             - Start database containers"
	@echo "  make down              - Stop containers (preserves data)"
	@echo "  make stop              - Stop containers without removing"
	@echo "  make remove            - Remove stopped containers"
	@echo "  make restart           - Restart containers"
	@echo ""
	@echo "Database Operations:"
	@echo "  make seed-data         - Populate databases with demo data"
	@echo "  make test-connections  - Test database connections"
	@echo "  make backup            - Create database backups"
	@echo "  make restore           - Restore from latest backup"
	@echo "  make stats             - Show database statistics"
	@echo ""
	@echo "Maintenance & Cleanup:"
	@echo "  make clean             - Full cleanup (containers + volumes)"
	@echo "  make rebuild           - Rebuild containers from scratch"
	@echo "  make recreate-mysql    - Recreate MySQL container only"
	@echo "  make recreate-postgres - Recreate PostgreSQL container only"
	@echo "  make recreate-all      - Recreate all containers"
	@echo "  make force-recreate    - Force recreate all (no confirmation)"
	@echo ""
	@echo "Monitoring & Debugging:"
	@echo "  make logs              - Show container logs"
	@echo "  make status            - Show container status"
	@echo "  make init              - Full initialization (start + seed)"
	@echo ""
	@echo "Database Access:"
	@echo "  make mysql-cli         - Connect to MySQL CLI"
	@echo "  make postgres-cli      - Connect to PostgreSQL CLI"
	@echo "  make shell-mysql       - Open shell in MySQL container"
	@echo "  make shell-postgres    - Open shell in PostgreSQL container"
	@echo ""
	@echo "Network Management:"
	@echo "  make create-network    - Create shared Docker network"
	@echo "  make remove-network    - Remove shared Docker network"
	@echo "  make fix-network       - Fix network configuration issues"
	@echo "  make network-info      - Show network and container information"
	@echo ""
	@echo "Connection Details:"
	@echo "  MySQL:      localhost:3306 (user: testuser, pass: testpass123, db: customer_db)"
	@echo "  PostgreSQL: localhost:5432 (user: testuser, pass: testpass123, db: customer_db)"

# Start database containers
start:
	@echo "Ensuring shared network exists..."
	-@docker network create shared_db_network 2>/dev/null || echo "Network 'shared_db_network' already exists or will be created by compose"
	@echo "Starting customer database containers..."
	docker-compose up -d
	@echo "Waiting for database initialization (30 seconds)..."
	@sleep 30 || timeout /t 30 /nobreak >nul 2>&1 || ping -n 31 127.0.0.1 >nul
	@echo ""
	@echo "Customer databases are ready!"
	@echo ""
	@echo "Host access (from host machine):"
	@echo "  MySQL:      localhost:3306 (user: testuser, pass: testpass123, db: customer_db)"
	@echo "  PostgreSQL: localhost:5432 (user: testuser, pass: testpass123, db: customer_db)"
	@echo ""
	@echo "Container access (from other Docker containers on shared_db_network):"
	@echo "  MySQL:      mysql:3306 (user: testuser, pass: testpass123, db: customer_db)"
	@echo "  PostgreSQL: postgres:5432 (user: testuser, pass: testpass123, db: customer_db)"
	@echo ""
	@echo "Run 'make seed-data' to populate with demo data"
	@echo "Run 'make network-info' for detailed network information"

# Stop and remove containers (preserves data volumes)
down:
	@echo "Stopping and removing containers..."
	docker-compose down
	@echo "Containers stopped successfully!"

# Stop containers without removing
stop:
	@echo "Stopping containers..."
	docker-compose stop
	@echo "Containers stopped (not removed)"

# Remove stopped containers
remove:
	@echo "Removing stopped containers..."
	docker-compose rm -f
	@echo "Containers removed successfully!"

# Restart containers
restart: down start
	@echo "Containers restarted successfully!"

# Show container logs
logs:
	@echo "Showing container logs (press Ctrl+C to exit)..."
	docker-compose logs -f

# Show container status
status:
	@echo "=== Container Status ==="
	@docker-compose ps
	@echo ""
	@echo "=== Volume Information ==="
	@docker volume ls | grep bce_test_db || docker volume ls | findstr bce_test_db || echo "No volumes found"

# Recreate MySQL container only
recreate-mysql:
	@echo "Recreating MySQL container..."
	docker-compose stop mysql
	docker-compose rm -f mysql
	docker-compose up -d mysql
	@echo "Waiting for MySQL initialization..."
	@sleep 30 || timeout /t 30 /nobreak >nul 2>&1 || ping -n 31 127.0.0.1 >nul
	@echo "MySQL container recreated successfully!"

# Recreate PostgreSQL container only
recreate-postgres:
	@echo "Recreating PostgreSQL container..."
	docker-compose stop postgres
	docker-compose rm -f postgres
	docker-compose up -d postgres
	@echo "Waiting for PostgreSQL initialization..."
	@sleep 30 || timeout /t 30 /nobreak >nul 2>&1 || ping -n 31 127.0.0.1 >nul
	@echo "PostgreSQL container recreated successfully!"

# Recreate all containers
recreate-all:
	@echo "This will recreate all containers. Data will be preserved in volumes."
	@echo "Press Ctrl+C to cancel or Enter to continue..."
	@read -p "" dummy 2>/dev/null || true
	@$(MAKE) down
	@$(MAKE) start
	@echo "All containers recreated successfully!"

# Force recreate without confirmation
force-recreate: down start
	@echo "All containers force recreated!"

# Populate databases with comprehensive demo data
seed-data:
	@echo "=== Database Demo Data Status ==="
	@echo ""
	@echo "Demo data is automatically loaded during container initialization!"
	@echo "MySQL: Loaded from mysql/init/02_demo_data.sql (stored procedures + execution)"
	@echo "PostgreSQL: Loaded from postgres/init/02_demo_data.sql (direct INSERT statements)"
	@echo ""
	@echo "Tables created with proper naming convention:"
	@echo "- Table names: lowercase (customers, orders, products, etc.)"
	@echo "- Field names: UPPERCASE (ID, CUSTOMER_CODE, FIRST_NAME, etc.)"
	@echo ""
	@echo "To manually regenerate MySQL data (use stored procedures):"
	@echo "  docker exec test_mysql_db mysql -u testuser -ptestpass123 customer_db -e 'CALL GenerateCustomers(80);'"
	@echo "  docker exec test_mysql_db mysql -u testuser -ptestpass123 customer_db -e 'CALL GenerateOrders(150);'"
	@echo ""
	@echo "Current data statistics:"
	@$(MAKE) stats

# Test database connections
test-connections:
	@echo "Testing database connections..."
	@echo "Testing MySQL connection..."
	@docker exec test_mysql_db mysql -u testuser -ptestpass123 -e "SELECT 'MySQL Connection OK' as status, VERSION() as version, DATABASE() as current_db;" customer_db
	@echo ""
	@echo "Testing PostgreSQL connection..."
	@docker exec test_postgres_db psql -U testuser -d customer_db -c "SELECT 'PostgreSQL Connection OK' as status, version() as version, current_database() as current_db;"
	@echo ""
	@echo "Database connections tested successfully!"

# Show database statistics
stats:
	@echo "=== Customer Database Statistics ==="
	@echo ""
	@echo "MySQL Statistics:"
	-@docker exec test_mysql_db mysql -u testuser -ptestpass123 customer_db -e "SELECT 'customers' as table_name, COUNT(*) as count FROM customers UNION SELECT 'companies', COUNT(*) FROM companies UNION SELECT 'products', COUNT(*) FROM products UNION SELECT 'orders', COUNT(*) FROM orders UNION SELECT 'order_items', COUNT(*) FROM order_items UNION SELECT 'leads', COUNT(*) FROM leads UNION SELECT 'tasks', COUNT(*) FROM tasks UNION SELECT 'deals', COUNT(*) FROM deals;" || echo "MySQL not accessible"
	@echo ""
	@echo "PostgreSQL Statistics:"
	-@docker exec test_postgres_db psql -U testuser -d customer_db -c "SELECT 'customers' as table_name, COUNT(*) as count FROM customers UNION SELECT 'companies', COUNT(*) FROM companies UNION SELECT 'products', COUNT(*) FROM products UNION SELECT 'orders', COUNT(*) FROM orders UNION SELECT 'order_items', COUNT(*) FROM order_items UNION SELECT 'leads', COUNT(*) FROM leads UNION SELECT 'tasks', COUNT(*) FROM tasks UNION SELECT 'deals', COUNT(*) FROM deals ORDER BY table_name;" || echo "PostgreSQL not accessible"

# Full cleanup - removes containers and data volumes
clean:
	@echo "WARNING: This will remove all containers and data volumes!"
	@echo "Press Ctrl+C to cancel or Enter to continue..."
	@read -p "" dummy 2>/dev/null || true
	@echo "Performing full cleanup..."
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "Full cleanup completed!"

# Rebuild containers from scratch
rebuild: clean
	@echo "Rebuilding containers from scratch..."
	docker-compose build --no-cache
	@$(MAKE) start
	@echo "Containers rebuilt successfully!"

# Full initialization: start containers + populate data
init: start
	@echo "Waiting for databases to be ready before seeding..."
	@sleep 15 || timeout /t 15 /nobreak >nul 2>&1 || ping -n 16 127.0.0.1 >nul
	@$(MAKE) seed-data
	@echo ""
	@echo "=== Full initialization completed! ==="
	@echo "Customer databases are ready with comprehensive demo data"

# Database CLI access commands
mysql-cli:
	@echo "Connecting to MySQL customer database..."
	@echo "Available tables: customers, companies, customer_companies, addresses, orders, etc."
	@docker exec -it test_mysql_db mysql -u testuser -ptestpass123 customer_db

postgres-cli:
	@echo "Connecting to PostgreSQL customer database..."
	@echo "Available tables: customers, companies, customer_companies, addresses, orders, etc."
	@docker exec -it test_postgres_db psql -U testuser -d customer_db


# Create database backups
backup:
	@echo "Creating database backups..."
	@mkdir -p backups 2>/dev/null || mkdir backups 2>nul || echo "Backups directory exists"
	@echo "Backing up MySQL customer database..."
	docker exec test_mysql_db mysqldump -u testuser -ptestpass123 --single-transaction --routines --triggers customer_db > backups/mysql_customer_backup.sql
	@echo "Backing up PostgreSQL customer database..."
	docker exec test_postgres_db pg_dump -U testuser --verbose --clean --no-acl --no-owner -d customer_db > backups/postgres_customer_backup.sql
	@echo ""
	@echo "Database backups created in backups/ directory"
	@echo "Files created:"
	@ls -la backups/*backup*.sql 2>/dev/null || dir backups\*backup*.sql 2>nul || echo "No backup files found"

# Restore from latest backup (interactive)
restore:
	@echo "=== Database Restore ==="
	@echo "Available backup files:"
	@ls -la backups/*.sql 2>/dev/null || dir backups\*.sql 2>nul || echo "No backup files found in backups/ directory"
	@echo ""
	@echo "WARNING: This will overwrite existing data!"
	@echo "Make sure containers are running (make start)"
	@echo "Specify backup file manually using docker exec commands"
	@echo ""
	@echo "Example restore commands:"
	@echo "MySQL:      docker exec -i test_mysql_db mysql -u testuser -ptestpass123 customer_db < backups/filename.sql"
	@echo "PostgreSQL: docker exec -i test_postgres_db psql -U testuser -d customer_db -f /tmp/filename.sql"


# Container shell access commands
shell-mysql:
	@echo "Opening shell in MySQL container..."
	@echo "Use 'exit' to leave the container shell"
	@docker exec -it test_mysql_db /bin/bash

shell-postgres:
	@echo "Opening shell in PostgreSQL container..."
	@echo "Use 'exit' to leave the container shell"
	@docker exec -it test_postgres_db /bin/bash

# Network management commands
create-network:
	@echo "Creating shared Docker network for database access..."
	-@docker network create shared_db_network 2>/dev/null || echo "Network 'shared_db_network' already exists"
	@echo "Network 'shared_db_network' is ready for use"
	@echo ""
	@echo "Other containers can now connect using:"
	@echo "  docker run --network shared_db_network your_container"
	@echo "  Or add to docker-compose.yml:"
	@echo "    networks:"
	@echo "      - shared_db_network"
	@echo ""
	@echo "Database hostnames within network:"
	@echo "  MySQL: mysql (port 3306)"
	@echo "  PostgreSQL: postgres (port 5432)"

remove-network:
	@echo "Stopping containers before removing network..."
	@$(MAKE) down
	@echo "Removing shared Docker network..."
	-@docker network rm shared_db_network 2>/dev/null || echo "Network 'shared_db_network' does not exist or already removed"
	@echo "Network removed successfully"

# Fix network issues - recreate network with correct labels
fix-network:
	@echo "Fixing network configuration issues..."
	@echo "Stopping containers..."
	@$(MAKE) down
	@echo "Removing existing network..."
	-@docker network rm shared_db_network 2>/dev/null || echo "Network doesn't exist"
	@echo "Creating network with correct configuration..."
	@docker network create shared_db_network
	@echo "Network fixed successfully"

network-info:
	@echo "=== Docker Network Information ==="
	@echo ""
	@echo "Shared network details:"
	-@docker network inspect shared_db_network 2>/dev/null || echo "Network 'shared_db_network' not found. Run 'make create-network' first."
	@echo ""
	@echo "Connected containers:"
	-@docker network ls --filter name=shared_db_network --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}" || echo "No networks found"
	@echo ""
	@echo "Database container status:"
	-@docker ps --filter name=test_mysql_db --filter name=test_postgres_db --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || echo "No database containers running"
	@echo ""
	@echo "Connection examples for other containers:"
	@echo "  MySQL connection string: mysql://testuser:testpass123@mysql:3306/customer_db"
	@echo "  PostgreSQL connection string: postgresql://testuser:testpass123@postgres:5432/customer_db"

