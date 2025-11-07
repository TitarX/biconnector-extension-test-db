USE customer_db;

DELIMITER $$

CREATE PROCEDURE GenerateCustomers(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO customers (CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE, DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE)
        VALUES (
            CONCAT('CUST', LPAD(i + 1, 5, '0')),
            CONCAT('FirstName', i + 1),
            CONCAT('LastName', i + 1),
            CONCAT('customer', i + 1, '@example.com'),
            CONCAT('123-456-', LPAD(i + 1, 4, '0')),
            CONCAT('987-654-', LPAD(i + 1, 4, '0')),
            DATE_SUB(CURDATE(), INTERVAL (18 + FLOOR(RAND() * 50)) YEAR),
            ELT(FLOOR(1 + RAND() * 4), 'Male', 'Female', 'Other', 'Prefer not to say'),
            ELT(FLOOR(1 + RAND() * 4), 'Active', 'Inactive', 'Suspended', 'Pending'),
            ELT(FLOOR(1 + RAND() * 4), 'Individual', 'Business', 'Enterprise', 'VIP')
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateCompanies(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO companies (COMPANY_NAME, INDUSTRY, COMPANY_SIZE, ANNUAL_REVENUE, EMPLOYEE_COUNT)
        VALUES (
            CONCAT('Company', i + 1),
            ELT(FLOOR(1 + RAND() * 5), 'Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing'),
            ELT(FLOOR(1 + RAND() * 5), 'Startup', 'Small', 'Medium', 'Large', 'Enterprise'),
            RAND() * 10000000,
            FLOOR(RAND() * 5000)
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateProducts(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO products (PRODUCT_NAME, PRICE, SKU, STOCK_QUANTITY)
        VALUES (
            CONCAT('Product ', i + 1),
            ROUND(RAND() * 1000, 2),
            CONCAT('SKU', LPAD(i + 1, 6, '0')),
            FLOOR(RAND() * 1000)
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateOrders(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_count INT;
    DECLARE product_count INT;
    SELECT COUNT(*) INTO customer_count FROM CUSTOMERS;
    SELECT COUNT(*) INTO product_count FROM PRODUCTS;

    WHILE i < num_rows DO
        INSERT INTO orders (CUSTOMER_ID, STATUS, TOTAL_AMOUNT)
        VALUES (
            (SELECT ID FROM CUSTOMERS ORDER BY RAND() LIMIT 1),
            ELT(FLOOR(1 + RAND() * 5), 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'),
            ROUND(RAND() * 5000, 2)
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateOrderItems(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;
    DECLARE product_id INT;
    DECLARE unit_price DECIMAL(10, 2);

    WHILE i < num_rows DO
        SELECT ID INTO order_id FROM ORDERS ORDER BY RAND() LIMIT 1;
        SELECT ID, PRICE INTO product_id, unit_price FROM PRODUCTS ORDER BY RAND() LIMIT 1;

        INSERT INTO order_items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
        VALUES (
            order_id,
            product_id,
            FLOOR(1 + RAND() * 10),
            unit_price
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateLeads(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO leads (FIRST_NAME, LAST_NAME, EMAIL, PHONE, COMPANY_NAME, STATUS, SOURCE)
        VALUES (
            CONCAT('LeadFirst', i + 1),
            CONCAT('LeadLast', i + 1),
            CONCAT('lead', i + 1, '@example.com'),
            CONCAT('555-123-', LPAD(i + 1, 4, '0')),
            CONCAT('Lead Company ', i + 1),
            ELT(FLOOR(1 + RAND() * 5), 'New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'),
            ELT(FLOOR(1 + RAND() * 4), 'Web', 'Referral', 'Partner', 'Advertisement')
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateTasks(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO tasks (TITLE, DUE_DATE, PRIORITY, STATUS)
        VALUES (
            CONCAT('Task ', i + 1),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 90) DAY),
            ELT(FLOOR(1 + RAND() * 4), 'Low', 'Medium', 'High', 'Critical'),
            ELT(FLOOR(1 + RAND() * 4), 'Not Started', 'In Progress', 'Completed', 'Deferred')
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateDeals(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO deals (DEAL_NAME, AMOUNT, STAGE, CLOSE_DATE)
        VALUES (
            CONCAT('Deal ', i + 1),
            ROUND(RAND() * 100000, 2),
            ELT(FLOOR(1 + RAND() * 6), 'Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 180) DAY)
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateInvoices(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;
    DECLARE total_amount DECIMAL(10,2);
    WHILE i < num_rows DO
        SELECT ID, TOTAL_AMOUNT INTO order_id, total_amount FROM ORDERS ORDER BY RAND() LIMIT 1;
        INSERT INTO invoices (ORDER_ID, INVOICE_DATE, DUE_DATE, TOTAL_AMOUNT, STATUS)
        VALUES (
            order_id,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 30 DAY),
            total_amount,
            ELT(FLOOR(1 + RAND() * 5), 'Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled')
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateDeliveries(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id INT;
    WHILE i < num_rows DO
        SELECT ID INTO order_id FROM ORDERS ORDER BY RAND() LIMIT 1;
        INSERT INTO deliveries (ORDER_ID, SHIPPING_DATE, DELIVERY_DATE, CARRIER, TRACKING_NUMBER, STATUS)
        VALUES (
            order_id,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 7 DAY),
            ELT(FLOOR(1 + RAND() * 3), 'UPS', 'FedEx', 'DHL'),
            CONCAT('TRK', LPAD(FLOOR(RAND() * 1000000000), 9, '0')),
            ELT(FLOOR(1 + RAND() * 5), 'Preparing', 'Shipped', 'In Transit', 'Delivered', 'Failed')
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateAddresses(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id INT;
    WHILE i < num_rows DO
        SELECT ID INTO customer_id FROM CUSTOMERS ORDER BY RAND() LIMIT 1;
        INSERT INTO addresses (CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT)
        VALUES (
            customer_id,
            ELT(FLOOR(1 + RAND() * 5), 'Home', 'Work', 'Billing', 'Shipping', 'Other'),
            CONCAT('Street ', i + 1, ', Building ', FLOOR(RAND() * 100)),
            CONCAT('City', FLOOR(RAND() * 50)),
            CONCAT('State', FLOOR(RAND() * 20)),
            LPAD(FLOOR(RAND() * 99999), 5, '0'),
            CONCAT('Country', FLOOR(RAND() * 10)),
            RAND() < 0.3
        );
        SET i = i + 1;
    END WHILE;
END$$

CREATE PROCEDURE GenerateCommunicationPreferences(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id INT;
    WHILE i < num_rows DO
        SELECT ID INTO customer_id FROM CUSTOMERS ORDER BY RAND() LIMIT 1;
        INSERT INTO COMMUNICATION_PREFERENCES (CUSTOMER_ID, EMAIL_MARKETING, SMS_MARKETING, PHONE_CALLS, PREFERRED_CONTACT_METHOD, CONTACT_FREQUENCY)
        VALUES (
            customer_id,
            RAND() < 0.7,
            RAND() < 0.3,
            RAND() < 0.2,
            ELT(FLOOR(1 + RAND() * 4), 'Email', 'Phone', 'SMS', 'Mail'),
            ELT(FLOOR(1 + RAND() * 5), 'Daily', 'Weekly', 'Monthly', 'Quarterly', 'Never')
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Generate Data
CALL GenerateCustomers(5000);
CALL GenerateCompanies(1000);
CALL GenerateAddresses(8000);
CALL GenerateCommunicationPreferences(5000);
CALL GenerateProducts(2000);
CALL GenerateOrders(10000);
CALL GenerateOrderItems(25000);
CALL GenerateLeads(5000);
CALL GenerateTasks(10000);
CALL GenerateDeals(3000);
CALL GenerateInvoices(9000);
CALL GenerateDeliveries(8000);

