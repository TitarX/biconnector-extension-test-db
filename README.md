# Тестовые базы данных Docker

Этот проект содержит две тестовые базы данных (MySQL и PostgreSQL) с демо данными клиентов, запускаемые в Docker контейнерах.

## Структура проекта

```
├── docker-compose.yml          # Конфигурация Docker Compose
├── Makefile                   # Команды для управления проектом
├── mysql/
│   ├── init/
│   │   └── 01_create_tables.sql  # Создание таблиц MySQL
│   └── seed/
│       └── demo_data.sql         # Демо данные для MySQL
├── postgres/
│   ├── init/
│   │   └── 01_create_tables.sql  # Создание таблиц PostgreSQL
│   └── seed/
│       └── demo_data.sql         # Демо данные для PostgreSQL
└── README.md                  # Этот файл
```

## Быстрый старт

### С использованием Make (Linux/Mac/Windows с установленным Make)

1. **Запуск контейнеров с базами данных:**
   ```bash
   make start
   ```
   Эта команда создает контейнеры и общую Docker сеть для доступа других контейнеров.

2. **Заполнение баз данных демо данными:**
   ```bash
   make seed-data
   ```

### Напрямую через Docker Compose

1. **Запуск контейнеров:**
   ```bash
   docker-compose -p test-databases up -d
   ```

2. **Заполнение данными:**
   ```bash
   # MySQL
   docker exec -i test_mysql_db mysql -u testuser -ptestpass123 test_db < mysql/seed/demo_data.sql
   
   # PostgreSQL
   docker cp postgres/seed/demo_data.sql test_postgres_db:/tmp/demo_data.sql
   docker exec -i test_postgres_db psql -U testuser -d test_db -f /tmp/demo_data.sql
   ```

## Доступные команды

### Make команды (Linux/Mac/Windows с Make)
- `make help` - Показать справку по всем доступным командам
- `make start` - Запустить контейнеры с базами данных
- `make down` - Остановить контейнеры
- `make restart` - Перезапустить контейнеры
- `make logs` - Показать логи контейнеров
- `make status` - Показать статус контейнеров
- `make seed-data` - Заполнить базы данных демо данными
- `make clean` - Полная очистка (контейнеры + данные)

## Подключение к базам данных

### MySQL
- **Хост:** localhost
- **Порт:** 3306
- **База данных:** test_db
- **Пользователь:** testuser
- **Пароль:** testpass123
- **Root пароль:** root123

**Строка подключения:**
```
mysql://testuser:testpass123@localhost:3306/test_db
```

**Подключение через командную строку:**
```bash
mysql -h localhost -P 3306 -u testuser -ptestpass123 test_db
```

### PostgreSQL
- **Хост:** localhost
- **Порт:** 5432
- **База данных:** test_db
- **Пользователь:** testuser
- **Пароль:** testpass123

**Строка подключения:**
```
postgresql://testuser:testpass123@localhost:5432/test_db
```

**Подключение через командную строку:**
```bash
psql -h localhost -p 5432 -U testuser -d test_db
```

## Доступ из других Docker контейнеров

Базы данных доступны для других Docker контейнеров по именам сервисов через общую сеть `shared_db_network`.

### Подключение контейнера к сети:

**Метод 1: Запуск контейнера с сетью**
```bash
docker run --network shared_db_network your_image
```

**Метод 2: Подключение существующего контейнера**
```bash
docker network connect shared_db_network your_container_name
```

**Метод 3: Docker Compose**
```yaml
version: '3.8'
services:
  your_app:
    image: your_image
    networks:
      - shared_db_network

networks:
  shared_db_network:
    external: true
    name: shared_db_network
```

### Подключение из контейнеров:

**MySQL из других контейнеров:**
- **Хост:** `mysql` (имя сервиса)
- **Порт:** 3306
- **Строка подключения:** `mysql://testuser:testpass123@mysql:3306/customer_db`

**PostgreSQL из других контейнеров:**
- **Хост:** `postgres` (имя сервиса)  
- **Порт:** 5432
- **Строка подключения:** `postgresql://testuser:testpass123@postgres:5432/customer_db`

### Команды для управления сетью:
- `make network-info` - Информация о сети и подключениях
- `make create-network` - Создать сеть вручную (автоматически создается при `make start`)
- `make remove-network` - Удалить сеть

📖 **Подробная инструкция:** См. файл `NETWORK_ACCESS_GUIDE.md` для детальных примеров подключения.

## Описание демо данных

### MySQL - Таблица `clients`
Содержит данные корпоративных клиентов российских компаний:
- Личная информация (имя, фамилия, email, телефон)
- Рабочая информация (компания, должность)
- Адресные данные (страна, город, адрес)
- Финансовая информация (баланс)
- Метаданные (даты регистрации, активность)

### PostgreSQL - Таблица `users`
Содержит данные пользователей международной IT-платформы:
- Профильная информация (username, полное имя, email)
- Профессиональная информация (организация, должность)
- Локализация (страна, город, предпочитаемый язык)
- Подписка и балансовая информация
- UUID идентификаторы

## Особенности

- **Внешний доступ:** Базы данных доступны не только через localhost, но и по внешнему IP
- **Постоянные данные:** Данные сохраняются в Docker volumes
- **Разные структуры:** MySQL и PostgreSQL имеют разные схемы и типы данных
- **Уникальные данные:** Демо данные в базах не повторяются и представляют разные бизнес-кейсы
- **Автоматическая инициализация:** Таблицы создаются автоматически при первом запуске

## Требования

- Docker
- Docker Compose
- Make (для Windows можно использовать Chocolatey: `choco install make`)

## Безопасность

⚠️ **Внимание:** Этот проект предназначен только для тестирования и разработки. Не используйте эти настройки в продакшене!

- Пароли и учетные данные хранятся в открытом виде
- Базы данных доступны извне без дополнительной защиты
- Отсутствуют SSL сертификаты
