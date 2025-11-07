USE customer_db;

SET FOREIGN_KEY_CHECKS = 0;

DELIMITER $$

-- Procedure to generate customers
CREATE PROCEDURE GenerateCustomers(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO customers (CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE, DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE)
        VALUES (
            CONCAT('CUST', LPAD(i + 1, 6, '0')),
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

-- Procedure to generate companies
CREATE PROCEDURE GenerateCompanies(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO companies (COMPANY_NAME, INDUSTRY, COMPANY_SIZE, ANNUAL_REVENUE, EMPLOYEE_COUNT, WEBSITE, FOUNDED_YEAR)
        VALUES (
            CONCAT('Company ', i + 1, ' Ltd'),
            ELT(FLOOR(1 + RAND() * 10), 'Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing', 'Education', 'Construction', 'Transportation', 'Energy', 'Media'),
            ELT(FLOOR(1 + RAND() * 5), 'Startup', 'Small', 'Medium', 'Large', 'Enterprise'),
            ROUND(RAND() * 50000000, 2),
            FLOOR(RAND() * 10000) + 1,
            CONCAT('https://www.company', i + 1, '.com'),
            1950 + FLOOR(RAND() * 73)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate products
CREATE PROCEDURE GenerateProducts(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO products (PRODUCT_CODE, NAME, DESCRIPTION, CATEGORY, SUBCATEGORY, BRAND, PRICE, COST, STOCK_QUANTITY, MIN_STOCK_LEVEL, IS_ACTIVE)
        VALUES (
            CONCAT('PROD', LPAD(i + 1, 6, '0')),
            CONCAT('Product ', i + 1),
            CONCAT('Description for product ', i + 1),
            ELT(FLOOR(1 + RAND() * 8), 'Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports', 'Toys', 'Beauty', 'Automotive'),
            ELT(FLOOR(1 + RAND() * 5), 'Subcategory A', 'Subcategory B', 'Subcategory C', 'Subcategory D', 'Subcategory E'),
            ELT(FLOOR(1 + RAND() * 10), 'Brand A', 'Brand B', 'Brand C', 'Brand D', 'Brand E', 'Brand F', 'Brand G', 'Brand H', 'Brand I', 'Brand J'),
            ROUND(RAND() * 1000 + 10, 2),
            ROUND(RAND() * 500 + 5, 2),
            FLOOR(RAND() * 1000),
            FLOOR(RAND() * 50),
            IF(RAND() > 0.1, TRUE, FALSE)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate addresses
CREATE PROCEDURE GenerateAddresses(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;

        INSERT INTO addresses (CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT)
        VALUES (
            customer_id_var,
            ELT(FLOOR(1 + RAND() * 5), 'Home', 'Work', 'Billing', 'Shipping', 'Other'),
            CONCAT('Street ', i + 1, ', Building ', FLOOR(RAND() * 100) + 1),
            ELT(FLOOR(1 + RAND() * 20), 'Moscow', 'St. Petersburg', 'Novosibirsk', 'Yekaterinburg', 'Nizhny Novgorod', 'Kazan', 'Chelyabinsk', 'Omsk', 'Samara', 'Rostov-on-Don', 'Ufa', 'Krasnoyarsk', 'Voronezh', 'Perm', 'Volgograd', 'Krasnodar', 'Saratov', 'Tyumen', 'Tolyatti', 'Izhevsk'),
            ELT(FLOOR(1 + RAND() * 10), 'Moscow Region', 'Leningrad Region', 'Sverdlovsk Region', 'Tatarstan', 'Bashkortostan', 'Chelyabinsk Region', 'Novosibirsk Region', 'Samara Region', 'Krasnoyarsk Region', 'Rostov Region'),
            CONCAT(FLOOR(RAND() * 900000) + 100000),
            'Russia',
            IF(i % 3 = 0, TRUE, FALSE)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate orders
CREATE PROCEDURE GenerateOrders(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;
    DECLARE subtotal_var DECIMAL(10,2);
    DECLARE tax_var DECIMAL(10,2);
    DECLARE shipping_var DECIMAL(10,2);
    DECLARE discount_var DECIMAL(10,2);

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;
        SET subtotal_var = ROUND(RAND() * 5000 + 50, 2);
        SET tax_var = ROUND(subtotal_var * 0.2, 2);
        SET shipping_var = ROUND(RAND() * 100 + 10, 2);
        SET discount_var = ROUND(RAND() * 200, 2);

        INSERT INTO orders (ORDER_NUMBER, CUSTOMER_ID, STATUS, PAYMENT_METHOD, PAYMENT_STATUS, SUBTOTAL, TAX_AMOUNT, SHIPPING_AMOUNT, DISCOUNT_AMOUNT, TOTAL_AMOUNT, ORDER_DATE)
        VALUES (
            CONCAT('ORD', LPAD(i + 1, 8, '0')),
            customer_id_var,
            ELT(FLOOR(1 + RAND() * 6), 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded'),
            ELT(FLOOR(1 + RAND() * 6), 'Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash', 'Crypto'),
            ELT(FLOOR(1 + RAND() * 5), 'Pending', 'Paid', 'Failed', 'Refunded', 'Partially Refunded'),
            subtotal_var,
            tax_var,
            shipping_var,
            discount_var,
            subtotal_var + tax_var + shipping_var - discount_var,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate order items
CREATE PROCEDURE GenerateOrderItems(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE order_id_var INT;
    DECLARE product_id_var INT;
    DECLARE quantity_var INT;
    DECLARE unit_price_var DECIMAL(10,2);

    WHILE i < num_rows DO
        SELECT ID INTO order_id_var FROM orders ORDER BY RAND() LIMIT 1;
        SELECT ID INTO product_id_var FROM products ORDER BY RAND() LIMIT 1;
        SET quantity_var = FLOOR(RAND() * 5) + 1;
        SELECT PRICE INTO unit_price_var FROM products WHERE ID = product_id_var;

        INSERT INTO order_items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, TOTAL_PRICE, DISCOUNT_AMOUNT)
        VALUES (
            order_id_var,
            product_id_var,
            quantity_var,
            unit_price_var,
            unit_price_var * quantity_var,
            ROUND(RAND() * 50, 2)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate leads
CREATE PROCEDURE GenerateLeads(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_rows DO
        INSERT INTO leads (LEAD_CODE, FIRST_NAME, LAST_NAME, COMPANY_NAME, EMAIL, PHONE, SOURCE, STATUS, SCORE, ASSIGNED_TO)
        VALUES (
            CONCAT('LEAD', LPAD(i + 1, 6, '0')),
            CONCAT('LeadFirst', i + 1),
            CONCAT('LeadLast', i + 1),
            CONCAT('Lead Company ', i + 1),
            CONCAT('lead', i + 1, '@potential.com'),
            CONCAT('555-', LPAD(FLOOR(RAND() * 10000), 4, '0'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0')),
            ELT(FLOOR(1 + RAND() * 8), 'Website', 'Social Media', 'Email Campaign', 'Referral', 'Cold Call', 'Trade Show', 'Advertisement', 'Partner'),
            ELT(FLOOR(1 + RAND() * 5), 'New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'),
            FLOOR(RAND() * 100),
            ELT(FLOOR(1 + RAND() * 5), 'Sales Rep A', 'Sales Rep B', 'Sales Rep C', 'Sales Rep D', 'Sales Rep E')
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate deals
CREATE PROCEDURE GenerateDeals(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;
    DECLARE lead_id_var INT;

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;
        SELECT ID INTO lead_id_var FROM leads ORDER BY RAND() LIMIT 1;

        INSERT INTO deals (DEAL_NAME, CUSTOMER_ID, LEAD_ID, STAGE, VALUE, PROBABILITY, EXPECTED_CLOSE_DATE, ASSIGNED_TO)
        VALUES (
            CONCAT('Deal ', i + 1, ' - ', ELT(FLOOR(1 + RAND() * 5), 'Software License', 'Consulting', 'Hardware', 'Support', 'Training')),
            IF(RAND() > 0.3, customer_id_var, NULL),
            IF(RAND() > 0.5, lead_id_var, NULL),
            ELT(FLOOR(1 + RAND() * 6), 'Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'),
            ROUND(RAND() * 100000 + 1000, 2),
            FLOOR(RAND() * 100),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 180) DAY),
            ELT(FLOOR(1 + RAND() * 5), 'Sales Rep A', 'Sales Rep B', 'Sales Rep C', 'Sales Rep D', 'Sales Rep E')
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate tasks
CREATE PROCEDURE GenerateTasks(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;
    DECLARE lead_id_var INT;
    DECLARE deal_id_var INT;

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;
        SELECT ID INTO lead_id_var FROM leads ORDER BY RAND() LIMIT 1;
        SELECT ID INTO deal_id_var FROM deals ORDER BY RAND() LIMIT 1;

        INSERT INTO tasks (TITLE, DESCRIPTION, CUSTOMER_ID, LEAD_ID, DEAL_ID, ASSIGNED_TO, STATUS, PRIORITY, DUE_DATE, ESTIMATED_HOURS)
        VALUES (
            CONCAT('Task ', i + 1, ' - ', ELT(FLOOR(1 + RAND() * 6), 'Follow up call', 'Send proposal', 'Meeting preparation', 'Contract review', 'Technical demo', 'Training session')),
            CONCAT('Task description for task ', i + 1),
            IF(RAND() > 0.5, customer_id_var, NULL),
            IF(RAND() > 0.7, lead_id_var, NULL),
            IF(RAND() > 0.6, deal_id_var, NULL),
            ELT(FLOOR(1 + RAND() * 8), 'John Smith', 'Jane Doe', 'Mike Johnson', 'Sarah Wilson', 'David Brown', 'Lisa Davis', 'Tom Anderson', 'Amy Taylor'),
            ELT(FLOOR(1 + RAND() * 4), 'Not Started', 'In Progress', 'Completed', 'Deferred'),
            ELT(FLOOR(1 + RAND() * 4), 'Low', 'Medium', 'High', 'Critical'),
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 60) DAY),
            ROUND(RAND() * 8 + 1, 1)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate invoices
CREATE PROCEDURE GenerateInvoices(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;
    DECLARE order_id_var INT;
    DECLARE deal_id_var INT;
    DECLARE subtotal_var DECIMAL(12,2);
    DECLARE tax_rate_var DECIMAL(5,2);
    DECLARE tax_amount_var DECIMAL(12,2);

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;
        SELECT ID INTO order_id_var FROM orders ORDER BY RAND() LIMIT 1;
        SELECT ID INTO deal_id_var FROM deals ORDER BY RAND() LIMIT 1;
        SET subtotal_var = ROUND(RAND() * 10000 + 100, 2);
        SET tax_rate_var = 20.00;
        SET tax_amount_var = ROUND(subtotal_var * tax_rate_var / 100, 2);

        INSERT INTO invoices (INVOICE_NUMBER, CUSTOMER_ID, ORDER_ID, DEAL_ID, INVOICE_DATE, DUE_DATE, STATUS, SUBTOTAL, TAX_RATE, TAX_AMOUNT, TOTAL_AMOUNT)
        VALUES (
            CONCAT('INV', LPAD(i + 1, 8, '0')),
            customer_id_var,
            IF(RAND() > 0.5, order_id_var, NULL),
            IF(RAND() > 0.7, deal_id_var, NULL),
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 90) DAY),
            DATE_ADD(DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 90) DAY), INTERVAL 30 DAY),
            ELT(FLOOR(1 + RAND() * 5), 'Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled'),
            subtotal_var,
            tax_rate_var,
            tax_amount_var,
            subtotal_var + tax_amount_var
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Procedure to generate support tickets
CREATE PROCEDURE GenerateSupportTickets(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE customer_id_var INT;

    WHILE i < num_rows DO
        SELECT ID INTO customer_id_var FROM customers ORDER BY RAND() LIMIT 1;

        INSERT INTO support_tickets (TICKET_NUMBER, CUSTOMER_ID, SUBJECT, DESCRIPTION, PRIORITY, STATUS, CATEGORY, ASSIGNED_TO)
        VALUES (
            CONCAT('TICKET', LPAD(i + 1, 6, '0')),
            customer_id_var,
            ELT(FLOOR(1 + RAND() * 10), 'Login Issues', 'Payment Problem', 'Product Defect', 'Shipping Delay', 'Feature Request', 'Technical Support', 'Account Access', 'Billing Question', 'Order Status', 'General Inquiry'),
            CONCAT('Support ticket description for ticket ', i + 1),
            ELT(FLOOR(1 + RAND() * 4), 'Low', 'Medium', 'High', 'Critical'),
            ELT(FLOOR(1 + RAND() * 5), 'Open', 'In Progress', 'Resolved', 'Closed', 'Reopened'),
            ELT(FLOOR(1 + RAND() * 6), 'Technical', 'Billing', 'Sales', 'General', 'Bug Report', 'Feature Request'),
            ELT(FLOOR(1 + RAND() * 6), 'Support Agent A', 'Support Agent B', 'Support Agent C', 'Support Agent D', 'Support Agent E', 'Support Agent F')
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Generate initial data
CALL GenerateCustomers(8000);
CALL GenerateCompanies(2000);
CALL GenerateProducts(5000);
CALL GenerateAddresses(12000);
CALL GenerateOrders(15000);
CALL GenerateOrderItems(35000);
CALL GenerateLeads(6000);
CALL GenerateDeals(4000);
CALL GenerateTasks(10000);
CALL GenerateInvoices(8000);
CALL GenerateSupportTickets(3000);

SET FOREIGN_KEY_CHECKS = 1;
