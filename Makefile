# Makefile для управления тестовыми базами данных
# Проект: Test Databases (MySQL + PostgreSQL)

.PHONY: help up down stop remove restart logs status seed-data clean rebuild init recreate-mysql recreate-postgres recreate-all force-recreate test-connections backup restore stats mysql-cli postgres-cli

# Default target - show help
all: help

# Show available commands
help:
	@echo "=== Customer Database Management Commands ==="
	@echo ""
	@echo "Basic Operations:"
	@echo "  make help              - Show this help menu"
	@echo "  make up                - Start database containers"
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
	@echo "  make init              - Full initialization (up + seed)"
	@echo ""
	@echo "Database Access:"
	@echo "  make mysql-cli         - Connect to MySQL CLI"
	@echo "  make postgres-cli      - Connect to PostgreSQL CLI"
	@echo ""
	@echo "Connection Details:"
	@echo "  MySQL:      localhost:3306 (user: testuser, pass: testpass123, db: customer_db)"
	@echo "  PostgreSQL: localhost:5432 (user: testuser, pass: testpass123, db: customer_db)"

# Start database containers
up:
	@echo "Starting customer database containers..."
	docker-compose -p customer-databases up -d
	@echo "Waiting for database initialization (45 seconds)..."
	@timeout /t 45 /nobreak > nul
	@echo ""
	@echo "Customer databases are ready!"
	@echo "MySQL:      localhost:3306 (user: testuser, pass: testpass123, db: customer_db)"
	@echo "PostgreSQL: localhost:5432 (user: testuser, pass: testpass123, db: customer_db)"
	@echo ""
	@echo "Run 'make seed-data' to populate with demo data"

# Stop and remove containers (preserves data volumes)
down:
	@echo "Stopping and removing containers..."
	docker-compose -p customer-databases down
	@echo "Containers stopped successfully!"

# Stop containers without removing
stop:
	@echo "Stopping containers..."
	docker-compose -p customer-databases stop
	@echo "Containers stopped (not removed)"

# Remove stopped containers
remove:
	@echo "Removing stopped containers..."
	docker-compose -p customer-databases rm -f
	@echo "Containers removed successfully!"

# Restart containers
restart: down up
	@echo "Containers restarted successfully!"

# Recreate MySQL container only
recreate-mysql:
	@echo "Recreating MySQL container..."
	docker-compose -p customer-databases stop mysql
	docker-compose -p customer-databases rm -f mysql
	docker-compose -p customer-databases up -d mysql
	@echo "Waiting for MySQL initialization..."
	@timeout /t 30 /nobreak > nul
	@echo "MySQL container recreated successfully!"

# Recreate PostgreSQL container only
recreate-postgres:
	@echo "Recreating PostgreSQL container..."
	docker-compose -p customer-databases stop postgres
	docker-compose -p customer-databases rm -f postgres
	docker-compose -p customer-databases up -d postgres
	@echo "Waiting for PostgreSQL initialization..."
	@timeout /t 30 /nobreak > nul
	@echo "PostgreSQL container recreated successfully!"

# Recreate all containers
recreate-all:
	@echo "This will recreate all containers. Data will be preserved in volumes."
	@echo "Press Ctrl+C to cancel or Enter to continue..."
	@pause > nul
	@$(MAKE) down
	@$(MAKE) up
	@echo "All containers recreated successfully!"

# Force recreate without confirmation
force-recreate: down up
	@echo "All containers force recreated!"

# Показать логи
logs:
	docker-compose -p test-databases logs -f

# Показать статус контейнеров
status:
	@echo "Статус контейнеров:"
	docker-compose -p test-databases ps

# Populate databases with comprehensive demo data
seed-data:
	@echo "Populating MySQL with comprehensive customer data..."
	docker exec -i test_mysql_db mysql -u testuser -ptestpass123 customer_db < mysql/seed/demo_data.sql
	@echo "MySQL data loaded successfully!"
	@echo ""
	@echo "Populating PostgreSQL with comprehensive customer data..."
	docker cp postgres/seed/demo_data.sql test_postgres_db:/tmp/demo_data.sql
	docker exec -i test_postgres_db psql -U testuser -d customer_db -f /tmp/demo_data.sql
	@echo "PostgreSQL data loaded successfully!"
	@echo ""
	@echo "Demo data successfully loaded into both databases!"
	@echo "- MySQL: 20 customers with companies, addresses, orders, interactions"
	@echo "- PostgreSQL: 20 users with companies, segments, tickets, preferences"

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

# Full cleanup - removes containers and data volumes
clean:
	@echo "WARNING: This will remove all containers and data volumes!"
	@echo "Press Ctrl+C to cancel or Enter to continue..."
	@pause > nul
	@echo "Performing full cleanup..."
	docker-compose -p customer-databases down -v --remove-orphans
	docker system prune -f
	@echo "Full cleanup completed!"

# Rebuild containers from scratch
rebuild: clean
	@echo "Rebuilding containers from scratch..."
	docker-compose -p customer-databases build --no-cache
	@$(MAKE) up
	@echo "Containers rebuilt successfully!"

# Full initialization: start containers + populate data
init: up
	@echo "Waiting for databases to be ready before seeding..."
	@timeout /t 15 /nobreak > nul
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

# Show container logs
logs:
	@echo "Showing container logs (press Ctrl+C to exit)..."
	docker-compose -p customer-databases logs -f

# Show container status
status:
	@echo "=== Container Status ==="
	@docker-compose -p customer-databases ps
	@echo ""
	@echo "=== Volume Information ==="
	@docker volume ls | findstr customer-databases

# Create database backups
backup:
	@echo "Creating database backups..."
	@if not exist backups mkdir backups
	@echo "Backing up MySQL customer database..."
	@docker exec test_mysql_db mysqldump -u testuser -ptestpass123 --single-transaction --routines --triggers customer_db > backups/mysql_customer_backup_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.sql
	@echo "Backing up PostgreSQL customer database..."
	@docker exec test_postgres_db pg_dump -U testuser --verbose --clean --no-acl --no-owner -d customer_db > backups/postgres_customer_backup_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.sql
	@echo ""
	@echo "Database backups created in backups/ directory"
	@echo "Files created:"
	@dir backups\*backup*.sql /B 2>nul | findstr backup

# Restore from latest backup (interactive)
restore:
	@echo "=== Database Restore ==="
	@echo "Available backup files:"
	@dir backups\*.sql /B 2>nul || echo "No backup files found in backups/ directory"
	@echo ""
	@echo "WARNING: This will overwrite existing data!"
	@echo "Make sure containers are running (make up)"
	@echo "Specify backup file manually using docker exec commands"
	@echo ""
	@echo "Example restore commands:"
	@echo "MySQL:      docker exec -i test_mysql_db mysql -u testuser -ptestpass123 customer_db < backups/filename.sql"
	@echo "PostgreSQL: docker exec -i test_postgres_db psql -U testuser -d customer_db -f /tmp/filename.sql"

# Quick database statistics
stats:
	@echo "=== Customer Database Statistics ==="
	@echo ""
	@echo "MySQL Statistics:"
	@docker exec test_mysql_db mysql -u testuser -ptestpass123 customer_db -e "SELECT 'customers' as table_name, COUNT(*) as count FROM customers UNION SELECT 'companies', COUNT(*) FROM companies UNION SELECT 'orders', COUNT(*) FROM orders UNION SELECT 'addresses', COUNT(*) FROM addresses;" 2>nul || echo "MySQL not accessible"
	@echo ""
	@echo "PostgreSQL Statistics:"
	@docker exec test_postgres_db psql -U testuser -d customer_db -c "SELECT 'customers' as table_name, COUNT(*) as count FROM customers UNION SELECT 'companies', COUNT(*) FROM companies UNION SELECT 'orders', COUNT(*) FROM orders UNION SELECT 'addresses', COUNT(*) FROM addresses ORDER BY table_name;" 2>nul || echo "PostgreSQL not accessible"
