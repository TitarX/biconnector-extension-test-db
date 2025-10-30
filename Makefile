.PHONY: help build up down restart logs clean seed-data

# Определение переменных
COMPOSE_FILE = docker-compose.yml
PROJECT_NAME = test-databases

# Справка по командам
help:
	@echo "Доступные команды:"
	@echo "  make build       - Собрать контейнеры"
	@echo "  make up          - Запустить контейнеры с базами данных"
	@echo "  make down        - Остановить и удалить контейнеры"
	@echo "  make restart     - Перезапустить контейнеры"
	@echo "  make logs        - Показать логи контейнеров"
	@echo "  make clean       - Полная очистка (контейнеры + volumes)"
	@echo "  make seed-data   - Заполнить базы данных демо данными"
	@echo "  make status      - Показать статус контейнеров"

# Собрать контейнеры
build:
	@echo "Сборка контейнеров..."
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) build

# Запустить контейнеры
up:
	@echo "Запуск контейнеров с базами данных..."
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d
	@echo "Ожидание инициализации баз данных (30 секунд)..."
	timeout /t 30 /nobreak > nul
	@echo "Базы данных готовы к работе!"
	@echo "MySQL: localhost:3306 (user: testuser, password: testpass123, db: test_db)"
	@echo "PostgreSQL: localhost:5432 (user: testuser, password: testpass123, db: test_db)"

# Остановить контейнеры
down:
	@echo "Остановка контейнеров..."
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down

# Перезапустить контейнеры
restart: down up

# Показать логи
logs:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) logs -f

# Показать статус контейнеров
status:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) ps

# Полная очистка
clean:
	@echo "Полная очистка контейнеров и данных..."
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down -v --remove-orphans
	docker system prune -f

# Заполнение баз данных демо данными
seed-data:
	@echo "Заполнение MySQL демо данными..."
	docker exec -i test_mysql_db mysql -u testuser -ptestpass123 test_db < mysql/seed/demo_data.sql
	@echo "Заполнение PostgreSQL демо данными..."
	docker cp postgres/seed/demo_data.sql test_postgres_db:/tmp/demo_data.sql
	docker exec -i test_postgres_db psql -U testuser -d test_db -f /tmp/demo_data.sql
	@echo "Демо данные успешно загружены в обе базы данных!"
