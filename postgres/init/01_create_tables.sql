-- Создание таблицы пользователей для PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    mobile_number VARCHAR(20),
    organization VARCHAR(100),
    job_title VARCHAR(100),
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP,
    account_status BOOLEAN DEFAULT TRUE,
    credit_balance NUMERIC(12,2) DEFAULT 0.00,
    nation VARCHAR(50),
    location VARCHAR(50),
    full_address TEXT,
    date_of_birth DATE,
    user_gender VARCHAR(10) CHECK (user_gender IN ('Male', 'Female', 'Other')),
    additional_info TEXT,
    subscription_type VARCHAR(20) DEFAULT 'Basic',
    preferred_language VARCHAR(10) DEFAULT 'en',
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_email_address ON users(email_address);
CREATE INDEX IF NOT EXISTS idx_organization ON users(organization);
CREATE INDEX IF NOT EXISTS idx_signup_date ON users(signup_date);
CREATE INDEX IF NOT EXISTS idx_username ON users(username);

-- Триггер для автоматического обновления modified_timestamp
CREATE OR REPLACE FUNCTION update_modified_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified_timestamp = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_modified_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_timestamp();
