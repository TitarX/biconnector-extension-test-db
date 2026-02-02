-- Grant remote access for MySQL users
-- This script runs first during initialization (00_ prefix)

-- Create root user accessible from any host
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root123';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Create testuser accessible from any host
CREATE USER IF NOT EXISTS 'testuser'@'%' IDENTIFIED BY 'testpass123';
GRANT ALL PRIVILEGES ON customer_db.* TO 'testuser'@'%';

-- Apply privileges
FLUSH PRIVILEGES;
