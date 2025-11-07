-- Massive demo data generation for PostgreSQL
-- This script generates thousands of records for testing

-- Function to generate massive customers (5000 records)
CREATE OR REPLACE FUNCTION generate_massive_customers(num_rows INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    batch_size INTEGER := 1000;
BEGIN
    WHILE i < num_rows LOOP
        INSERT INTO customers (
            CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE,
            DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE, PREFERRED_LANGUAGE,
            TIMEZONE, NOTES
        ) VALUES (
            'CUST' || LPAD((i + 1)::TEXT, 6, '0'),
            'FirstName' || (i + 1),
            'LastName' || (i + 1),
            'customer' || (i + 1) || '@example.com',
            '+1-555-' || LPAD(FLOOR(RANDOM() * 9999)::TEXT, 4, '0'),
            '+1-444-' || LPAD(FLOOR(RANDOM() * 9999)::TEXT, 4, '0'),
            CURRENT_DATE - INTERVAL '1 year' * (18 + FLOOR(RANDOM() * 50)),
            (ARRAY['Male', 'Female', 'Other', 'Prefer not to say'])[FLOOR(RANDOM() * 4 + 1)]::GENDER_TYPE,
            (ARRAY['Active', 'Inactive', 'Suspended', 'Pending'])[FLOOR(RANDOM() * 4 + 1)]::CUSTOMER_STATUS_TYPE,
            (ARRAY['Individual', 'Business', 'Enterprise', 'VIP'])[FLOOR(RANDOM() * 4 + 1)]::CUSTOMER_TYPE_ENUM,
            (ARRAY['en', 'ru', 'de', 'fr', 'es'])[FLOOR(RANDOM() * 5 + 1)],
            (ARRAY['UTC', 'America/New_York', 'Europe/London', 'Europe/Moscow', 'Asia/Tokyo', 'Australia/Sydney'])[FLOOR(RANDOM() * 6 + 1)],
            'Auto-generated customer #' || (i + 1) || ' for testing purposes'
        );

        i := i + 1;

        IF i % batch_size = 0 THEN
            RAISE NOTICE 'Generated % customers (batch %)', i, (i / batch_size);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate companies (2000 records)
CREATE OR REPLACE FUNCTION generate_massive_companies(num_rows INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    batch_size INTEGER := 500;
BEGIN
    WHILE i < num_rows LOOP
        INSERT INTO companies (
            COMPANY_NAME, LEGAL_NAME, REGISTRATION_NUMBER, TAX_NUMBER,
            INDUSTRY, COMPANY_SIZE, WEBSITE, FOUNDED_YEAR,
            DESCRIPTION, ANNUAL_REVENUE, EMPLOYEE_COUNT
        ) VALUES (
            'Company ' || (i + 1) || ' Ltd',
            'Company ' || (i + 1) || ' Limited Liability',
            'REG' || LPAD((i + 1)::TEXT, 8, '0'),
            'TAX' || LPAD((i + 1)::TEXT, 10, '0'),
            (ARRAY['Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing', 'Education', 'Real Estate', 'Consulting', 'Media', 'Transportation'])[FLOOR(RANDOM() * 10 + 1)],
            (ARRAY['Startup', 'Small', 'Medium', 'Large', 'Enterprise'])[FLOOR(RANDOM() * 5 + 1)]::COMPANY_SIZE_TYPE,
            'https://www.company' || (i + 1) || '.com',
            1990 + FLOOR(RANDOM() * 33)::INTEGER,
            'Leading company in its sector, established with focus on innovation and customer service. Company ID: ' || (i + 1),
            ROUND((RANDOM() * 50000000)::NUMERIC, 2),
            FLOOR(1 + RANDOM() * 10000)::INTEGER
        );

        i := i + 1;

        IF i % batch_size = 0 THEN
            RAISE NOTICE 'Generated % companies', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate products (3000 records)
CREATE OR REPLACE FUNCTION generate_massive_products(num_rows INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    batch_size INTEGER := 1000;
BEGIN
    WHILE i < num_rows LOOP
        INSERT INTO products (
            PRODUCT_NAME, DESCRIPTION, PRICE, SKU, STOCK_QUANTITY
        ) VALUES (
            'Product ' || (i + 1),
            'High-quality product designed for maximum efficiency and reliability. Product code: P' || LPAD((i + 1)::TEXT, 6, '0'),
            ROUND((10 + RANDOM() * 2000)::NUMERIC, 2),
            'SKU' || LPAD((i + 1)::TEXT, 8, '0'),
            FLOOR(RANDOM() * 5000)::INTEGER
        );

        i := i + 1;

        IF i % batch_size = 0 THEN
            RAISE NOTICE 'Generated % products', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate addresses (7500 records)
CREATE OR REPLACE FUNCTION generate_massive_addresses(num_customers INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    customer_uuid UUID;
    addresses_per_customer INTEGER;
    addr_count INTEGER := 0;
    j INTEGER;
    customers_cursor CURSOR FOR SELECT ID FROM customers ORDER BY ID LIMIT num_customers;
BEGIN
    FOR customer_record IN customers_cursor LOOP
        customer_uuid := customer_record.ID;
        addresses_per_customer := 1 + FLOOR(RANDOM() * 3)::INTEGER; -- 1 to 3 addresses
        j := 0;

        WHILE j < addresses_per_customer LOOP
            INSERT INTO addresses (
                CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, APARTMENT,
                CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT
            ) VALUES (
                customer_uuid,
                (ARRAY['Home', 'Work', 'Billing', 'Shipping', 'Other'])[FLOOR(RANDOM() * 5 + 1)]::ADDRESS_TYPE,
                FLOOR(1 + RANDOM() * 9999) || ' ' || (ARRAY['Main St', 'Oak Ave', 'Park Rd', 'First St', 'Second Ave', 'Broadway', 'Elm St', 'Maple Ave', 'Cedar Rd', 'Pine St'])[FLOOR(RANDOM() * 10 + 1)],
                CASE WHEN RANDOM() > 0.7 THEN 'Apt ' || FLOOR(1 + RANDOM() * 999) ELSE NULL END,
                (ARRAY['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Washington'])[FLOOR(RANDOM() * 20 + 1)],
                (ARRAY['CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI'])[FLOOR(RANDOM() * 10 + 1)],
                LPAD(FLOOR(10000 + RANDOM() * 89999)::TEXT, 5, '0'),
                'United States',
                CASE WHEN j = 0 THEN TRUE ELSE FALSE END
            );

            j := j + 1;
            addr_count := addr_count + 1;
        END LOOP;

        i := i + 1;

        IF i % 1000 = 0 THEN
            RAISE NOTICE 'Generated addresses for % customers (total: % addresses)', i, addr_count;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate orders (8000 records)
CREATE OR REPLACE FUNCTION generate_massive_orders(num_orders INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    customer_uuid UUID;
    shipping_addr_uuid UUID;
    billing_addr_uuid UUID;
BEGIN
    WHILE i < num_orders LOOP
        -- Get random customer
        SELECT ID INTO customer_uuid FROM customers ORDER BY RANDOM() LIMIT 1;

        -- Get random addresses for this customer
        SELECT ID INTO shipping_addr_uuid FROM addresses WHERE CUSTOMER_ID = customer_uuid ORDER BY RANDOM() LIMIT 1;
        SELECT ID INTO billing_addr_uuid FROM addresses WHERE CUSTOMER_ID = customer_uuid ORDER BY RANDOM() LIMIT 1;

        INSERT INTO orders (
            CUSTOMER_ID, ORDER_DATE, STATUS, TOTAL_AMOUNT,
            SHIPPING_ADDRESS_ID, BILLING_ADDRESS_ID
        ) VALUES (
            customer_uuid,
            NOW() - INTERVAL '1 day' * FLOOR(RANDOM() * 365),
            (ARRAY['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'])[FLOOR(RANDOM() * 5 + 1)]::ORDER_STATUS_TYPE,
            ROUND((50 + RANDOM() * 2000)::NUMERIC, 2),
            shipping_addr_uuid,
            billing_addr_uuid
        );

        i := i + 1;

        IF i % 2000 = 0 THEN
            RAISE NOTICE 'Generated % orders', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate order items (20000 records)
CREATE OR REPLACE FUNCTION generate_massive_order_items(num_items INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    order_uuid UUID;
    product_uuid UUID;
    quantity INTEGER;
    unit_price NUMERIC(10,2);
BEGIN
    WHILE i < num_items LOOP
        -- Get random order and product
        SELECT ID INTO order_uuid FROM orders ORDER BY RANDOM() LIMIT 1;
        SELECT ID INTO product_uuid FROM products ORDER BY RANDOM() LIMIT 1;
        SELECT PRICE INTO unit_price FROM products WHERE ID = product_uuid;

        quantity := 1 + FLOOR(RANDOM() * 10)::INTEGER;

        INSERT INTO order_items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
        VALUES (order_uuid, product_uuid, quantity, unit_price);

        i := i + 1;

        IF i % 5000 = 0 THEN
            RAISE NOTICE 'Generated % order items', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate leads (4000 records)
CREATE OR REPLACE FUNCTION generate_massive_leads(num_leads INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    assigned_to_uuid UUID;
BEGIN
    WHILE i < num_leads LOOP
        assigned_to_uuid := CASE WHEN RANDOM() > 0.3 THEN (SELECT ID FROM customers ORDER BY RANDOM() LIMIT 1) ELSE NULL END;

        INSERT INTO leads (
            FIRST_NAME, LAST_NAME, EMAIL, PHONE, COMPANY_NAME,
            STATUS, SOURCE, ASSIGNED_TO
        ) VALUES (
            'Lead' || (i + 1),
            'Prospect' || (i + 1),
            'lead' || (i + 1) || '@prospect.com',
            '+1-666-' || LPAD(FLOOR(RANDOM() * 9999)::TEXT, 4, '0'),
            'Prospect Company ' || (i + 1),
            (ARRAY['New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'])[FLOOR(RANDOM() * 5 + 1)]::LEAD_STATUS_TYPE,
            (ARRAY['Website', 'Referral', 'Cold Call', 'Email Campaign', 'Social Media', 'Trade Show', 'Advertisement', 'Partner'])[FLOOR(RANDOM() * 8 + 1)],
            assigned_to_uuid
        );

        i := i + 1;

        IF i % 1000 = 0 THEN
            RAISE NOTICE 'Generated % leads', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate tasks (6000 records)
CREATE OR REPLACE FUNCTION generate_massive_tasks(num_tasks INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    assigned_to_uuid UUID;
BEGIN
    WHILE i < num_tasks LOOP
        assigned_to_uuid := CASE WHEN RANDOM() > 0.2 THEN (SELECT ID FROM customers ORDER BY RANDOM() LIMIT 1) ELSE NULL END;

        INSERT INTO tasks (
            TITLE, DESCRIPTION, DUE_DATE, PRIORITY, STATUS,
            ASSIGNED_TO, RELATED_TO_TYPE, RELATED_TO_ID
        ) VALUES (
            'Task #' || (i + 1) || ' - ' || (ARRAY['Follow up', 'Review', 'Meeting', 'Analysis', 'Documentation', 'Implementation'])[FLOOR(RANDOM() * 6 + 1)],
            'Detailed description for task #' || (i + 1) || '. This task requires attention and proper execution.',
            CURRENT_DATE + INTERVAL '1 day' * FLOOR(RANDOM() * 90),
            (ARRAY['Low', 'Medium', 'High', 'Critical'])[FLOOR(RANDOM() * 4 + 1)]::PRIORITY_TYPE,
            (ARRAY['Not Started', 'In Progress', 'Completed', 'Deferred'])[FLOOR(RANDOM() * 4 + 1)]::TASK_STATUS_TYPE,
            assigned_to_uuid,
            (ARRAY['Customer', 'Order', 'Lead', 'Deal'])[FLOOR(RANDOM() * 4 + 1)],
            gen_random_uuid()
        );

        i := i + 1;

        IF i % 1500 = 0 THEN
            RAISE NOTICE 'Generated % tasks', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate deals (3000 records)
CREATE OR REPLACE FUNCTION generate_massive_deals(num_deals INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    company_uuid UUID;
    contact_person_uuid UUID;
    assigned_to_uuid UUID;
BEGIN
    WHILE i < num_deals LOOP
        company_uuid := CASE WHEN RANDOM() > 0.2 THEN (SELECT ID FROM companies ORDER BY RANDOM() LIMIT 1) ELSE NULL END;
        contact_person_uuid := CASE WHEN RANDOM() > 0.3 THEN (SELECT ID FROM customers ORDER BY RANDOM() LIMIT 1) ELSE NULL END;
        assigned_to_uuid := CASE WHEN RANDOM() > 0.1 THEN (SELECT ID FROM customers ORDER BY RANDOM() LIMIT 1) ELSE NULL END;

        INSERT INTO deals (
            DEAL_NAME, COMPANY_ID, CONTACT_PERSON_ID, AMOUNT,
            STAGE, CLOSE_DATE, ASSIGNED_TO
        ) VALUES (
            'Deal #' || (i + 1) || ' - ' || (ARRAY['Software License', 'Consulting Services', 'Hardware Purchase', 'Support Contract', 'Training Program'])[FLOOR(RANDOM() * 5 + 1)],
            company_uuid,
            contact_person_uuid,
            ROUND((1000 + RANDOM() * 500000)::NUMERIC, 2),
            (ARRAY['Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'])[FLOOR(RANDOM() * 6 + 1)]::DEAL_STAGE_TYPE,
            CURRENT_DATE + INTERVAL '1 day' * FLOOR(RANDOM() * 180 - 90),
            assigned_to_uuid
        );

        i := i + 1;

        IF i % 1000 = 0 THEN
            RAISE NOTICE 'Generated % deals', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate invoices (5000 records)
CREATE OR REPLACE FUNCTION generate_massive_invoices(num_invoices INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    order_uuid UUID;
    total_amount NUMERIC(10,2);
BEGIN
    WHILE i < num_invoices LOOP
        SELECT ID, TOTAL_AMOUNT INTO order_uuid, total_amount FROM orders ORDER BY RANDOM() LIMIT 1;

        INSERT INTO invoices (
            ORDER_ID, INVOICE_DATE, DUE_DATE, TOTAL_AMOUNT, STATUS
        ) VALUES (
            order_uuid,
            CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 60),
            CURRENT_DATE + INTERVAL '1 day' * FLOOR(RANDOM() * 30),
            total_amount,
            (ARRAY['Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled'])[FLOOR(RANDOM() * 5 + 1)]::INVOICE_STATUS_TYPE
        );

        i := i + 1;

        IF i % 1250 = 0 THEN
            RAISE NOTICE 'Generated % invoices', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to generate deliveries (4500 records)
CREATE OR REPLACE FUNCTION generate_massive_deliveries(num_deliveries INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER := 0;
    order_uuid UUID;
    ship_date DATE;
BEGIN
    WHILE i < num_deliveries LOOP
        SELECT ID INTO order_uuid FROM orders ORDER BY RANDOM() LIMIT 1;
        ship_date := CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 30);

        INSERT INTO deliveries (
            ORDER_ID, SHIPPING_DATE, DELIVERY_DATE, CARRIER,
            TRACKING_NUMBER, STATUS
        ) VALUES (
            order_uuid,
            ship_date,
            ship_date + INTERVAL '1 day' * FLOOR(1 + RANDOM() * 7),
            (ARRAY['FedEx', 'UPS', 'DHL', 'USPS', 'Local Courier'])[FLOOR(RANDOM() * 5 + 1)],
            'TRK' || LPAD((i + 1)::TEXT, 10, '0'),
            (ARRAY['Preparing', 'Shipped', 'In Transit', 'Delivered', 'Failed'])[FLOOR(RANDOM() * 5 + 1)]::DELIVERY_STATUS_TYPE
        );

        i := i + 1;

        IF i % 1125 = 0 THEN
            RAISE NOTICE 'Generated % deliveries', i;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Execute all functions to generate massive demo data
SELECT 'Starting massive data generation for PostgreSQL...' as status;

SELECT generate_massive_customers(5000);
SELECT generate_massive_companies(2000);
SELECT generate_massive_products(3000);
SELECT generate_massive_addresses(5000);
SELECT generate_massive_orders(8000);
SELECT generate_massive_order_items(20000);
SELECT generate_massive_leads(4000);
SELECT generate_massive_tasks(6000);
SELECT generate_massive_deals(3000);
SELECT generate_massive_invoices(5000);
SELECT generate_massive_deliveries(4500);

-- Drop functions after use
DROP FUNCTION generate_massive_customers(INTEGER);
DROP FUNCTION generate_massive_companies(INTEGER);
DROP FUNCTION generate_massive_products(INTEGER);
DROP FUNCTION generate_massive_addresses(INTEGER);
DROP FUNCTION generate_massive_orders(INTEGER);
DROP FUNCTION generate_massive_order_items(INTEGER);
DROP FUNCTION generate_massive_leads(INTEGER);
DROP FUNCTION generate_massive_tasks(INTEGER);
DROP FUNCTION generate_massive_deals(INTEGER);
DROP FUNCTION generate_massive_invoices(INTEGER);
DROP FUNCTION generate_massive_deliveries(INTEGER);

SELECT 'Massive data generation completed for PostgreSQL!' as status;
