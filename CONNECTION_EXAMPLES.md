# Примеры подключения к тестовым базам данных

## MySQL Examples

### PHP (PDO)
```php
<?php
$mysql = new PDO(
    'mysql:host=localhost;port=3306;dbname=test_db;charset=utf8mb4',
    'testuser',
    'testpass123'
);

$stmt = $mysql->query("SELECT first_name, last_name, company FROM clients LIMIT 5");
$clients = $stmt->fetchAll(PDO::FETCH_ASSOC);
print_r($clients);
?>
```

### Python
```python
import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='testuser',
    password='testpass123',
    database='test_db'
)

cursor = conn.cursor(dictionary=True)
cursor.execute("SELECT first_name, last_name, company FROM clients LIMIT 5")
clients = cursor.fetchall()

for client in clients:
    print(f"{client['first_name']} {client['last_name']} - {client['company']}")

conn.close()
```

### Node.js
```javascript
const mysql = require('mysql2/promise');

async function getClients() {
    const connection = await mysql.createConnection({
        host: 'localhost',
        port: 3306,
        user: 'testuser',
        password: 'testpass123',
        database: 'test_db'
    });

    const [rows] = await connection.execute(
        'SELECT first_name, last_name, company FROM clients LIMIT 5'
    );
    
    console.log(rows);
    await connection.end();
}

getClients();
```

## PostgreSQL Examples

### PHP (PDO)
```php
<?php
$postgres = new PDO(
    'pgsql:host=localhost;port=5432;dbname=test_db',
    'testuser',
    'testpass123'
);

$stmt = $postgres->query("SELECT username, full_name, organization FROM users LIMIT 5");
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
print_r($users);
?>
```

### Python
```python
import psycopg2
from psycopg2.extras import RealDictCursor

conn = psycopg2.connect(
    host='localhost',
    port=5432,
    user='testuser',
    password='testpass123',
    database='test_db'
)

cursor = conn.cursor(cursor_factory=RealDictCursor)
cursor.execute("SELECT username, full_name, organization FROM users LIMIT 5")
users = cursor.fetchall()

for user in users:
    print(f"{user['username']} - {user['full_name']} ({user['organization']})")

conn.close()
```

### Node.js
```javascript
const { Client } = require('pg');

async function getUsers() {
    const client = new Client({
        host: 'localhost',
        port: 5432,
        user: 'testuser',
        password: 'testpass123',
        database: 'test_db'
    });

    await client.connect();
    
    const res = await client.query(
        'SELECT username, full_name, organization FROM users LIMIT 5'
    );
    
    console.log(res.rows);
    await client.end();
}

getUsers();
```

## Command Line Access

### MySQL
```bash
mysql -h localhost -P 3306 -u testuser -ptestpass123 test_db
```

### PostgreSQL
```bash
psql -h localhost -p 5432 -U testuser -d test_db
```

## Connection Strings

### MySQL
```
mysql://testuser:testpass123@localhost:3306/test_db
```

### PostgreSQL
```
postgresql://testuser:testpass123@localhost:5432/test_db
```

## Sample Queries

### MySQL (clients table)
```sql
-- Все клиенты по компаниям
SELECT company, COUNT(*) as client_count 
FROM clients 
GROUP BY company;

-- Клиенты с наибольшим балансом
SELECT first_name, last_name, company, balance 
FROM clients 
ORDER BY balance DESC 
LIMIT 5;

-- Активные клиенты из Москвы
SELECT first_name, last_name, company, phone 
FROM clients 
WHERE city = 'Москва' AND is_active = TRUE;
```

### PostgreSQL (users table)
```sql
-- Пользователи по странам
SELECT nation, COUNT(*) as user_count 
FROM users 
GROUP BY nation 
ORDER BY user_count DESC;

-- Пользователи с премиум подпиской
SELECT username, full_name, organization, credit_balance 
FROM users 
WHERE subscription_type = 'Premium' 
ORDER BY credit_balance DESC;

-- IT специалисты
SELECT username, full_name, job_title, organization 
FROM users 
WHERE job_title LIKE '%Developer%' OR job_title LIKE '%Engineer%';
```
