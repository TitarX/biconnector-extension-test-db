-- Comprehensive Customer Database Schema for PostgreSQL with UTF-8 encoding
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set database encoding to UTF8
SET client_encoding = 'UTF8';

-- Custom data types
CREATE TYPE customer_status_type AS ENUM ('Active', 'Inactive', 'Suspended', 'Pending');
CREATE TYPE customer_type_enum AS ENUM ('Individual', 'Business', 'Enterprise', 'VIP');
CREATE TYPE gender_type AS ENUM ('Male', 'Female', 'Other', 'Prefer not to say');
CREATE TYPE address_type AS ENUM ('Home', 'Work', 'Billing', 'Shipping', 'Other');
CREATE TYPE contact_method_type AS ENUM ('Email', 'Phone', 'SMS', 'Mail');
CREATE TYPE contact_frequency_type AS ENUM ('Daily', 'Weekly', 'Monthly', 'Quarterly', 'Never');
CREATE TYPE company_size_type AS ENUM ('Startup', 'Small', 'Medium', 'Large', 'Enterprise');
CREATE TYPE order_status_type AS ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded');
CREATE TYPE payment_method_type AS ENUM ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash', 'Crypto');
CREATE TYPE payment_status_type AS ENUM ('Pending', 'Paid', 'Failed', 'Refunded', 'Partially Refunded');
CREATE TYPE interaction_type AS ENUM ('Email', 'Phone', 'Meeting', 'Chat', 'Support', 'Sale', 'Marketing', 'Other');
CREATE TYPE outcome_type AS ENUM ('Positive', 'Negative', 'Neutral', 'Follow-up Required');
CREATE TYPE priority_type AS ENUM ('Low', 'Medium', 'High', 'Critical');
CREATE TYPE ticket_status_type AS ENUM ('Open', 'In Progress', 'Resolved', 'Closed', 'Reopened');

-- Customers table - main customer information
CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(25),
    mobile VARCHAR(25),
    date_of_birth DATE,
    gender gender_type DEFAULT 'Prefer not to say',
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE,
    status customer_status_type DEFAULT 'Active',
    customer_type customer_type_enum DEFAULT 'Individual',
    preferred_language VARCHAR(5) DEFAULT 'en',
    timezone VARCHAR(50) DEFAULT 'UTC',
    avatar_url VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Companies table - business customer information
CREATE TABLE IF NOT EXISTS companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name VARCHAR(200) NOT NULL,
    legal_name VARCHAR(200),
    registration_number VARCHAR(50),
    tax_number VARCHAR(50),
    industry VARCHAR(100),
    company_size company_size_type DEFAULT 'Small',
    website VARCHAR(255),
    founded_year INTEGER CHECK (founded_year > 1800 AND founded_year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    description TEXT,
    annual_revenue NUMERIC(15,2),
    employee_count INTEGER CHECK (employee_count >= 0),
    logo_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer company relationships
CREATE TABLE IF NOT EXISTS customer_companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    position VARCHAR(100),
    department VARCHAR(100),
    is_primary BOOLEAN DEFAULT FALSE,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_customer_company UNIQUE (customer_id, company_id)
);

-- Addresses table
CREATE TABLE IF NOT EXISTS addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    address_type address_type DEFAULT 'Home',
    street_address VARCHAR(255) NOT NULL,
    apartment VARCHAR(50),
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Communication preferences
CREATE TABLE IF NOT EXISTS communication_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    email_marketing BOOLEAN DEFAULT TRUE,
    sms_notifications BOOLEAN DEFAULT FALSE,
    phone_calls BOOLEAN DEFAULT TRUE,
    newsletter BOOLEAN DEFAULT FALSE,
    promotional_offers BOOLEAN DEFAULT TRUE,
    event_invitations BOOLEAN DEFAULT FALSE,
    preferred_contact_method contact_method_type DEFAULT 'Email',
    contact_frequency contact_frequency_type DEFAULT 'Weekly',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_customer_prefs UNIQUE (customer_id)
);

-- Customer segments
CREATE TABLE IF NOT EXISTS customer_segments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    segment_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    criteria JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer segment assignments
CREATE TABLE IF NOT EXISTS customer_segment_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    segment_id UUID NOT NULL REFERENCES customer_segments(id) ON DELETE CASCADE,
    assigned_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    assigned_by VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT unique_customer_segment UNIQUE (customer_id, segment_id)
);

-- Orders/Transactions table
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status order_status_type DEFAULT 'Pending',
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method payment_method_type DEFAULT 'Credit Card',
    payment_status payment_status_type DEFAULT 'Pending',
    shipping_method VARCHAR(100),
    tracking_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer interactions/activities log
CREATE TABLE IF NOT EXISTS customer_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    interaction_type interaction_type NOT NULL,
    subject VARCHAR(255),
    description TEXT,
    interaction_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    duration_minutes INTEGER CHECK (duration_minutes >= 0),
    outcome outcome_type DEFAULT 'Neutral',
    agent_name VARCHAR(100),
    channel VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer support tickets
CREATE TABLE IF NOT EXISTS support_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority priority_type DEFAULT 'Medium',
    status ticket_status_type DEFAULT 'Open',
    category VARCHAR(100),
    assigned_to VARCHAR(100),
    resolution TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_customers_customer_code ON customers(customer_code);
CREATE INDEX IF NOT EXISTS idx_customers_registration_date ON customers(registration_date);
CREATE INDEX IF NOT EXISTS idx_customers_status ON customers(status);
CREATE INDEX IF NOT EXISTS idx_customers_customer_type ON customers(customer_type);

CREATE INDEX IF NOT EXISTS idx_companies_company_name ON companies(company_name);
CREATE INDEX IF NOT EXISTS idx_companies_industry ON companies(industry);
CREATE INDEX IF NOT EXISTS idx_companies_company_size ON companies(company_size);

CREATE INDEX IF NOT EXISTS idx_customer_companies_customer_id ON customer_companies(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_companies_company_id ON customer_companies(company_id);

CREATE INDEX IF NOT EXISTS idx_addresses_customer_id ON addresses(customer_id);
CREATE INDEX IF NOT EXISTS idx_addresses_address_type ON addresses(address_type);
CREATE INDEX IF NOT EXISTS idx_addresses_country ON addresses(country);

CREATE INDEX IF NOT EXISTS idx_customer_segments_segment_name ON customer_segments(segment_name);
CREATE INDEX IF NOT EXISTS idx_customer_segments_is_active ON customer_segments(is_active);

CREATE INDEX IF NOT EXISTS idx_customer_segment_assignments_customer_id ON customer_segment_assignments(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_segment_assignments_segment_id ON customer_segment_assignments(segment_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);

CREATE INDEX IF NOT EXISTS idx_customer_interactions_customer_id ON customer_interactions(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_interactions_interaction_type ON customer_interactions(interaction_type);
CREATE INDEX IF NOT EXISTS idx_customer_interactions_interaction_date ON customer_interactions(interaction_date);
CREATE INDEX IF NOT EXISTS idx_customer_interactions_outcome ON customer_interactions(outcome);

CREATE INDEX IF NOT EXISTS idx_support_tickets_ticket_number ON support_tickets(ticket_number);
CREATE INDEX IF NOT EXISTS idx_support_tickets_customer_id ON support_tickets(customer_id);
CREATE INDEX IF NOT EXISTS idx_support_tickets_status ON support_tickets(status);
CREATE INDEX IF NOT EXISTS idx_support_tickets_priority ON support_tickets(priority);
CREATE INDEX IF NOT EXISTS idx_support_tickets_created_at ON support_tickets(created_at);

-- Create triggers for automatic updated_at timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_addresses_updated_at BEFORE UPDATE ON addresses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_communication_preferences_updated_at BEFORE UPDATE ON communication_preferences FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_segments_updated_at BEFORE UPDATE ON customer_segments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON support_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
