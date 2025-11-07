USE customer_db;

DELIMITER $$

-- Generate large amount of customers (5000 records)
CREATE PROCEDURE GenerateMassiveCustomers(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE batch_size INT DEFAULT 1000;
    DECLARE current_batch INT DEFAULT 0;

    WHILE i < num_rows DO
        INSERT INTO customers (
            CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE,
            DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE, PREFERRED_LANGUAGE,
            TIMEZONE, NOTES
        ) VALUES (
            CONCAT('CUST', LPAD(i + 1, 6, '0')),
            CONCAT('FirstName', i + 1),
            CONCAT('LastName', i + 1),
            CONCAT('customer', i + 1, '@example.com'),
            CONCAT('+1-555-', LPAD(FLOOR(RAND() * 9999), 4, '0')),
            CONCAT('+1-444-', LPAD(FLOOR(RAND() * 9999), 4, '0')),
            DATE_SUB(CURDATE(), INTERVAL (18 + FLOOR(RAND() * 50)) YEAR),
            ELT(FLOOR(1 + RAND() * 4), 'Male', 'Female', 'Other', 'Prefer not to say'),
            ELT(FLOOR(1 + RAND() * 4), 'Active', 'Inactive', 'Suspended', 'Pending'),
            ELT(FLOOR(1 + RAND() * 4), 'Individual', 'Business', 'Enterprise', 'VIP'),
            ELT(FLOOR(1 + RAND() * 5), 'en', 'ru', 'de', 'fr', 'es'),
            ELT(FLOOR(1 + RAND() * 6), 'UTC', 'America/New_York', 'Europe/London', 'Europe/Moscow', 'Asia/Tokyo', 'Australia/Sydney'),
            CONCAT('Auto-generated customer #', i + 1, ' for testing purposes')
        );

        SET i = i + 1;

        -- Commit every batch_size records
        IF i % batch_size = 0 THEN
            SET current_batch = current_batch + 1;
            SELECT CONCAT('Generated ', i, ' customers (batch ', current_batch, ')') as status;
        END IF;
    END WHILE;
END$$

-- Generate companies (2000 records)
CREATE PROCEDURE GenerateMassiveCompanies(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE batch_size INT DEFAULT 500;

    WHILE i < num_rows DO
        INSERT INTO companies (
            COMPANY_NAME, LEGAL_NAME, REGISTRATION_NUMBER, TAX_NUMBER,
            INDUSTRY, COMPANY_SIZE, WEBSITE, FOUNDED_YEAR,
            DESCRIPTION, ANNUAL_REVENUE, EMPLOYEE_COUNT
        ) VALUES (
            CONCAT('Company ', i + 1, ' Ltd'),
            CONCAT('Company ', i + 1, ' Limited Liability'),
            CONCAT('REG', LPAD(i + 1, 8, '0')),
            CONCAT('TAX', LPAD(i + 1, 10, '0')),
            ELT(FLOOR(1 + RAND() * 10), 'Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing', 'Education', 'Real Estate', 'Consulting', 'Media', 'Transportation'),
            ELT(FLOOR(1 + RAND() * 5), 'Startup', 'Small', 'Medium', 'Large', 'Enterprise'),
            CONCAT('https://www.company', i + 1, '.com'),
            1990 + FLOOR(RAND() * 33),
            CONCAT('Leading company in its sector, established with focus on innovation and customer service. Company ID: ', i + 1),
            ROUND(RAND() * 50000000, 2),
            FLOOR(1 + RAND() * 10000)
        );

        SET i = i + 1;

        IF i % batch_size = 0 THEN
            SELECT CONCAT('Generated ', i, ' companies') as status;
        END IF;
    END WHILE;
END$$

-- Generate products (3000 records)
CREATE PROCEDURE GenerateMassiveProducts(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE batch_size INT DEFAULT 1000;

    WHILE i < num_rows DO
        INSERT INTO products (
            PRODUCT_NAME, DESCRIPTION, PRICE, SKU, STOCK_QUANTITY
        ) VALUES (
            CONCAT('Product ', i + 1),
            CONCAT('High-quality product designed for maximum efficiency and reliability. Product code: P', LPAD(i + 1, 6, '0')),
            ROUND(10 + RAND() * 2000, 2),
            CONCAT('SKU', LPAD(i + 1, 8, '0')),
            FLOOR(RAND() * 5000)
        );

        SET i = i + 1;

        IF i % batch_size = 0 THEN
            SELECT CONCAT('Generated ', i, ' products') as status;
        END IF;
    END WHILE;
END$$

-- Generate addresses for customers (7500 records - 1.5 addresses per customer on average)
CREATE PROCEDURE GenerateMassiveAddresses(IN num_customers INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id INT;
    DECLARE addresses_per_customer INT;
    DECLARE addr_count INT DEFAULT 0;
    DECLARE j INT;

    WHILE i < num_customers DO
        SET customer_id = i + 1;
        SET addresses_per_customer = 1 + FLOOR(RAND() * 3); -- 1 to 3 addresses per customer
        SET j = 0;

        WHILE j < addresses_per_customer DO
            INSERT INTO addresses (
                CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, APARTMENT,
                CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT
            ) VALUES (
                customer_id,
                ELT(FLOOR(1 + RAND() * 5), 'Home', 'Work', 'Billing', 'Shipping', 'Other'),
                CONCAT(FLOOR(1 + RAND() * 9999), ' ', ELT(FLOOR(1 + RAND() * 10), 'Main St', 'Oak Ave', 'Park Rd', 'First St', 'Second Ave', 'Broadway', 'Elm St', 'Maple Ave', 'Cedar Rd', 'Pine St')),
                IF(RAND() > 0.7, CONCAT('Apt ', FLOOR(1 + RAND() * 999)), NULL),
                ELT(FLOOR(1 + RAND() * 20), 'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Washington'),
                ELT(FLOOR(1 + RAND() * 10), 'CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI'),
                LPAD(FLOOR(10000 + RAND() * 89999), 5, '0'),
                'United States',
                IF(j = 0, TRUE, FALSE) -- First address is default
            );

            SET j = j + 1;
            SET addr_count = addr_count + 1;
        END WHILE;

        SET i = i + 1;

        IF i % 1000 = 0 THEN
            SELECT CONCAT('Generated addresses for ', i, ' customers (total: ', addr_count, ' addresses)') as status;
        END IF;
    END WHILE;
END$$

-- Generate orders (8000 records)
CREATE PROCEDURE GenerateMassiveOrders(IN num_orders INT, IN max_customer_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id INT;
    DECLARE shipping_addr_id INT;
    DECLARE billing_addr_id INT;

    WHILE i < num_orders DO
        SET customer_id = 1 + FLOOR(RAND() * max_customer_id);

        -- Get random addresses for this customer
        SELECT ID INTO shipping_addr_id FROM addresses WHERE CUSTOMER_ID = customer_id ORDER BY RAND() LIMIT 1;
        SELECT ID INTO billing_addr_id FROM addresses WHERE CUSTOMER_ID = customer_id ORDER BY RAND() LIMIT 1;

        INSERT INTO orders (
            CUSTOMER_ID, ORDER_DATE, STATUS, TOTAL_AMOUNT,
            SHIPPING_ADDRESS_ID, BILLING_ADDRESS_ID
        ) VALUES (
            customer_id,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
            ELT(FLOOR(1 + RAND() * 5), 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'),
            ROUND(50 + RAND() * 2000, 2),
            shipping_addr_id,
            billing_addr_id
        );

        SET i = i + 1;

        IF i % 2000 = 0 THEN
            SELECT CONCAT('Generated ', i, ' orders') as status;
        END IF;
    END WHILE;
END$$

-- Generate order items (20000 records)
CREATE PROCEDURE GenerateMassiveOrderItems(IN num_items INT, IN max_order_id INT, IN max_product_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;
    DECLARE product_id INT;
    DECLARE quantity INT;
    DECLARE unit_price DECIMAL(10,2);

    WHILE i < num_items DO
        SET order_id = 1 + FLOOR(RAND() * max_order_id);
        SET product_id = 1 + FLOOR(RAND() * max_product_id);
        SET quantity = 1 + FLOOR(RAND() * 10);

        -- Get product price
        SELECT PRICE INTO unit_price FROM products WHERE ID = product_id;

        INSERT INTO order_items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
        VALUES (order_id, product_id, quantity, unit_price);

        SET i = i + 1;

        IF i % 5000 = 0 THEN
            SELECT CONCAT('Generated ', i, ' order items') as status;
        END IF;
    END WHILE;
END$$

-- Generate leads (4000 records)
CREATE PROCEDURE GenerateMassiveLeads(IN num_leads INT, IN max_customer_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE assigned_to INT;

    WHILE i < num_leads DO
        SET assigned_to = IF(RAND() > 0.3, 1 + FLOOR(RAND() * max_customer_id), NULL);

        INSERT INTO leads (
            FIRST_NAME, LAST_NAME, EMAIL, PHONE, COMPANY_NAME,
            STATUS, SOURCE, ASSIGNED_TO
        ) VALUES (
            CONCAT('Lead', i + 1),
            CONCAT('Prospect', i + 1),
            CONCAT('lead', i + 1, '@prospect.com'),
            CONCAT('+1-666-', LPAD(FLOOR(RAND() * 9999), 4, '0')),
            CONCAT('Prospect Company ', i + 1),
            ELT(FLOOR(1 + RAND() * 5), 'New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'),
            ELT(FLOOR(1 + RAND() * 8), 'Website', 'Referral', 'Cold Call', 'Email Campaign', 'Social Media', 'Trade Show', 'Advertisement', 'Partner'),
            assigned_to
        );

        SET i = i + 1;

        IF i % 1000 = 0 THEN
            SELECT CONCAT('Generated ', i, ' leads') as status;
        END IF;
    END WHILE;
END$$

-- Generate tasks (6000 records)
CREATE PROCEDURE GenerateMassiveTasks(IN num_tasks INT, IN max_customer_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE assigned_to INT;

    WHILE i < num_tasks DO
        SET assigned_to = IF(RAND() > 0.2, 1 + FLOOR(RAND() * max_customer_id), NULL);

        INSERT INTO tasks (
            TITLE, DESCRIPTION, DUE_DATE, PRIORITY, STATUS,
            ASSIGNED_TO, RELATED_TO_TYPE, RELATED_TO_ID
        ) VALUES (
            CONCAT('Task #', i + 1, ' - ', ELT(FLOOR(1 + RAND() * 6), 'Follow up', 'Review', 'Meeting', 'Analysis', 'Documentation', 'Implementation')),
            CONCAT('Detailed description for task #', i + 1, '. This task requires attention and proper execution.'),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 90) DAY),
            ELT(FLOOR(1 + RAND() * 4), 'Low', 'Medium', 'High', 'Critical'),
            ELT(FLOOR(1 + RAND() * 4), 'Not Started', 'In Progress', 'Completed', 'Deferred'),
            assigned_to,
            ELT(FLOOR(1 + RAND() * 4), 'Customer', 'Order', 'Lead', 'Deal'),
            1 + FLOOR(RAND() * 1000)
        );

        SET i = i + 1;

        IF i % 1500 = 0 THEN
            SELECT CONCAT('Generated ', i, ' tasks') as status;
        END IF;
    END WHILE;
END$$

-- Generate deals (3000 records)
CREATE PROCEDURE GenerateMassiveDeals(IN num_deals INT, IN max_company_id INT, IN max_customer_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE company_id INT;
    DECLARE contact_person_id INT;
    DECLARE assigned_to INT;

    WHILE i < num_deals DO
        SET company_id = IF(RAND() > 0.2, 1 + FLOOR(RAND() * max_company_id), NULL);
        SET contact_person_id = IF(RAND() > 0.3, 1 + FLOOR(RAND() * max_customer_id), NULL);
        SET assigned_to = IF(RAND() > 0.1, 1 + FLOOR(RAND() * max_customer_id), NULL);

        INSERT INTO deals (
            DEAL_NAME, COMPANY_ID, CONTACT_PERSON_ID, AMOUNT,
            STAGE, CLOSE_DATE, ASSIGNED_TO
        ) VALUES (
            CONCAT('Deal #', i + 1, ' - ', ELT(FLOOR(1 + RAND() * 5), 'Software License', 'Consulting Services', 'Hardware Purchase', 'Support Contract', 'Training Program')),
            company_id,
            contact_person_id,
            ROUND(1000 + RAND() * 500000, 2),
            ELT(FLOOR(1 + RAND() * 6), 'Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 180 - 90) DAY),
            assigned_to
        );

        SET i = i + 1;

        IF i % 1000 = 0 THEN
            SELECT CONCAT('Generated ', i, ' deals') as status;
        END IF;
    END WHILE;
END$$

-- Generate invoices (5000 records)
CREATE PROCEDURE GenerateMassiveInvoices(IN num_invoices INT, IN max_order_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;
    DECLARE total_amount DECIMAL(10,2);

    WHILE i < num_invoices DO
        SET order_id = 1 + FLOOR(RAND() * max_order_id);

        -- Get order total amount
        SELECT TOTAL_AMOUNT INTO total_amount FROM orders WHERE ID = order_id;

        INSERT INTO invoices (
            ORDER_ID, INVOICE_DATE, DUE_DATE, TOTAL_AMOUNT, STATUS
        ) VALUES (
            order_id,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 60) DAY),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY),
            total_amount,
            ELT(FLOOR(1 + RAND() * 5), 'Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled')
        );

        SET i = i + 1;

        IF i % 1250 = 0 THEN
            SELECT CONCAT('Generated ', i, ' invoices') as status;
        END IF;
    END WHILE;
END$$

-- Generate deliveries (4500 records)
CREATE PROCEDURE GenerateMassiveDeliveries(IN num_deliveries INT, IN max_order_id INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;

    WHILE i < num_deliveries DO
        SET order_id = 1 + FLOOR(RAND() * max_order_id);

        INSERT INTO deliveries (
            ORDER_ID, SHIPPING_DATE, DELIVERY_DATE, CARRIER,
            TRACKING_NUMBER, STATUS
        ) VALUES (
            order_id,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY),
            DATE_ADD(DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), INTERVAL FLOOR(1 + RAND() * 7) DAY),
            ELT(FLOOR(1 + RAND() * 5), 'FedEx', 'UPS', 'DHL', 'USPS', 'Local Courier'),
            CONCAT('TRK', LPAD(i + 1, 10, '0')),
            ELT(FLOOR(1 + RAND() * 5), 'Preparing', 'Shipped', 'In Transit', 'Delivered', 'Failed')
        );

        SET i = i + 1;

        IF i % 1125 = 0 THEN
            SELECT CONCAT('Generated ', i, ' deliveries') as status;
        END IF;
    END WHILE;
END$$

DELIMITER ;

-- Execute all procedures to generate massive demo data
SELECT 'Starting massive data generation...' as status;

CALL GenerateMassiveCustomers(5000);
CALL GenerateMassiveCompanies(2000);
CALL GenerateMassiveProducts(3000);
CALL GenerateMassiveAddresses(5000);
CALL GenerateMassiveOrders(8000, 5000);
CALL GenerateMassiveOrderItems(20000, 8000, 3000);
CALL GenerateMassiveLeads(4000, 5000);
CALL GenerateMassiveTasks(6000, 5000);
CALL GenerateMassiveDeals(3000, 2000, 5000);
CALL GenerateMassiveInvoices(5000, 8000);
CALL GenerateMassiveDeliveries(4500, 8000);

-- Drop procedures after use
DROP PROCEDURE GenerateMassiveCustomers;
DROP PROCEDURE GenerateMassiveCompanies;
DROP PROCEDURE GenerateMassiveProducts;
DROP PROCEDURE GenerateMassiveAddresses;
DROP PROCEDURE GenerateMassiveOrders;
DROP PROCEDURE GenerateMassiveOrderItems;
DROP PROCEDURE GenerateMassiveLeads;
DROP PROCEDURE GenerateMassiveTasks;
DROP PROCEDURE GenerateMassiveDeals;
DROP PROCEDURE GenerateMassiveInvoices;
DROP PROCEDURE GenerateMassiveDeliveries;

SELECT 'Massive data generation completed!' as status;
