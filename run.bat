@echo off
chcp 65001 >nul
REM Script for managing Docker containers with databases (Windows)

if "%1"=="help" goto :help
if "%1"=="up" goto :up
if "%1"=="start" goto :up
if "%1"=="down" goto :down
if "%1"=="restart" goto :restart
if "%1"=="logs" goto :logs
if "%1"=="status" goto :status
if "%1"=="seed-data" goto :seed-data
if "%1"=="clean" goto :clean

:help
echo Available commands:
echo   run.bat start       - Start database containers (creates shared network)
echo   run.bat up          - Start database containers (alias for start)
echo   run.bat down        - Stop containers
echo   run.bat restart     - Restart containers
echo   run.bat logs        - Show container logs
echo   run.bat status      - Show container status
echo   run.bat seed-data   - Fill databases with demo data
echo   run.bat clean       - Full cleanup (containers + volumes)
echo   run.bat help        - Show this help
goto :end

:up
echo Creating shared network if it doesn't exist...
docker network create shared_db_network 2>nul || echo Network already exists
echo Starting database containers...
docker-compose -p test-databases up -d
echo Waiting for database initialization (30 seconds)...
timeout /t 30 /nobreak >nul
echo Databases are ready to work!
echo.
echo Host access:
echo   MySQL: localhost:3306 (user: testuser, password: testpass123, db: customer_db)
echo   PostgreSQL: localhost:5432 (user: testuser, password: testpass123, db: customer_db)
echo.
echo Container access (from shared_db_network):
echo   MySQL: mysql:3306 (user: testuser, password: testpass123, db: customer_db)
echo   PostgreSQL: postgres:5432 (user: testuser, password: testpass123, db: customer_db)
goto :end

:down
echo Stopping containers...
docker-compose -p test-databases down
goto :end

:restart
echo Restarting containers...
docker-compose -p test-databases down
echo Creating shared network if it doesn't exist...
docker network create shared_db_network 2>nul || echo Network already exists
docker-compose -p test-databases up -d
echo Waiting for database initialization (30 seconds)...
timeout /t 30 /nobreak >nul
echo Databases are ready to work!
goto :end

:logs
docker-compose -p test-databases logs -f
goto :end

:status
docker-compose -p test-databases ps
goto :end

:seed-data
echo Filling MySQL with demo data...
docker exec -i test_mysql_db mysql -u testuser -ptestpass123 test_db < mysql/seed/demo_data.sql
echo Filling PostgreSQL with demo data...
docker cp postgres/seed/demo_data.sql test_postgres_db:/tmp/demo_data.sql
docker exec -i test_postgres_db psql -U testuser -d test_db -f /tmp/demo_data.sql
echo Demo data successfully loaded into both databases!
goto :end

:clean
echo Full cleanup of containers and data...
docker-compose -p test-databases down -v --remove-orphans
docker system prune -f
goto :end

:end
