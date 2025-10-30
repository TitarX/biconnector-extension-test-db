# Makefile для управления тестовыми базами данных
# Проект: Test Databases (MySQL + PostgreSQL)

.PHONY: help up down restart logs status seed-data clean rebuild init

# По умолчанию показываем помощь
all: help

# Показать справку по командам
help:
	@echo "Доступные команды:"
	@echo "  make help        - Показать эту справку"
	@echo "  make up          - Запустить контейнеры с базами данных"
	@echo "  make down        - Остановить контейнеры"
	@echo "  make restart     - Перезапустить контейнеры"
	@echo "  make logs        - Показать логи контейнеров"
	@echo "  make status      - Показать статус контейнеров"
	@echo "  make seed-data   - Заполнить базы демонстрационными данными"
	@echo "  make clean       - Полная очистка (контейнеры + тома)"
	@echo "  make rebuild     - Пересоздать контейнеры с нуля"
	@echo "  make init        - Полная инициализация (up + seed-data)"

# Запустить контейнеры
up:
	@echo "Запуск контейнеров с базами данных..."
	docker-compose -p test-databases up -d
	@echo "Ожидание инициализации баз данных (30 секунд)..."
	@timeout /t 30 /nobreak > nul
	@echo "Базы данных готовы к работе!"
	@echo "MySQL: localhost:3306 (пользователь: testuser, пароль: testpass123, БД: test_db)"
	@echo "PostgreSQL: localhost:5432 (пользователь: testuser, пароль: testpass123, БД: test_db)"

# Остановить контейнеры
down:
	@echo "Остановка контейнеров..."
	docker-compose -p test-databases down

# Перезапустить контейнеры
restart: down up
	@echo "Контейнеры перезапущены!"

# Показать логи
logs:
	docker-compose -p test-databases logs -f

# Показать статус контейнеров
status:
	@echo "Статус контейнеров:"
	docker-compose -p test-databases ps

# Заполнить базы тестовыми данными
seed-data:
	@echo "Заполнение MySQL демонстрационными данными..."
	docker exec -i test_mysql_db mysql -u testuser -ptestpass123 test_db < mysql/seed/demo_data.sql
	@echo "Заполнение PostgreSQL демонстрационными данными..."
	docker cp postgres/seed/demo_data.sql test_postgres_db:/tmp/demo_data.sql
	docker exec -i test_postgres_db psql -U testuser -d test_db -f /tmp/demo_data.sql
	@echo "Демонстрационные данные успешно загружены в обе базы данных!"

# Полная очистка контейнеров и данных
clean:
	@echo "Полная очистка контейнеров и данных..."
	docker-compose -p test-databases down -v --remove-orphans
	docker system prune -f
	@echo "Очистка завершена!"

# Пересоздать контейнеры с нуля
rebuild: clean
	@echo "Пересоздание контейнеров..."
	docker-compose -p test-databases build --no-cache
	@$(MAKE) up
	@echo "Контейнеры пересозданы!"

# Полная инициализация: запуск + заполнение данными
init: up
	@echo "Ожидание готовности баз данных перед заполнением..."
	@timeout /t 10 /nobreak > nul
	@$(MAKE) seed-data
	@echo "Полная инициализация завершена!"

# Команды для разработки
dev-mysql:
	@echo "Подключение к MySQL..."
	docker exec -it test_mysql_db mysql -u testuser -ptestpass123 test_db

dev-postgres:
	@echo "Подключение к PostgreSQL..."
	docker exec -it test_postgres_db psql -U testuser -d test_db

# Бэкап баз данных
backup:
	@echo "Создание резервных копий баз данных..."
	@if not exist backups mkdir backups
	docker exec test_mysql_db mysqldump -u testuser -ptestpass123 test_db > backups/mysql_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
	docker exec test_postgres_db pg_dump -U testuser test_db > backups/postgres_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
	@echo "Резервные копии созданы в папке backups/"
