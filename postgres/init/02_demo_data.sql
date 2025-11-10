-- Demo data for PostgreSQL Customer Database
-- Table names: lowercase, Field names: UPPERCASE
-- Generates thousands of records for comprehensive testing

-- Set client encoding
SET client_encoding = 'UTF8';

-- First generate base tables
-- Generate Companies data (1000 records)
INSERT INTO companies ("COMPANY_NAME", "LEGAL_NAME", "REGISTRATION_NUMBER", "TAX_NUMBER", "INDUSTRY", "COMPANY_SIZE", "WEBSITE", "FOUNDED_YEAR", "DESCRIPTION", "ANNUAL_REVENUE", "EMPLOYEE_COUNT", "LOGO_URL")
SELECT
    'Company ' || gs || ' LLC',
    'Legal Name of Company ' || gs,
    'REG' || LPAD(gs::text, 8, '0'),
    'TAX' || LPAD(gs::text, 10, '0'),
    CASE (random() * 10)::int
        WHEN 0 THEN 'Technology'
        WHEN 1 THEN 'Healthcare'
        WHEN 2 THEN 'Finance'
        WHEN 3 THEN 'Manufacturing'
        WHEN 4 THEN 'Retail'
        WHEN 5 THEN 'Education'
        WHEN 6 THEN 'Energy'
        WHEN 7 THEN 'Consulting'
        WHEN 8 THEN 'Agriculture'
        ELSE 'Other'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Startup'
        WHEN 1 THEN 'Small'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Large'
        ELSE 'Enterprise'
    END,
    'https://company' || gs || '.com',
    1990 + (random() * 33)::int,
    'Company description for company number ' || gs || '. This is a sample description.',
    (random() * 100000000)::decimal(15,2),
    (random() * 10000)::int + 1,
    'https://logo.company' || gs || '.com/logo.png'
FROM generate_series(1, 1000) AS gs;

-- Generate Customers data (8000 records)
INSERT INTO customers ("CUSTOMER_CODE", "FIRST_NAME", "LAST_NAME", "EMAIL", "PHONE", "MOBILE", "DATE_OF_BIRTH", "GENDER", "REGISTRATION_DATE", "LAST_LOGIN", "STATUS", "CUSTOMER_TYPE", "PREFERRED_LANGUAGE", "TIMEZONE", "AVATAR_URL", "NOTES")
SELECT
    'CUST' || LPAD(gs::text, 6, '0'),
    CASE (random() * 20)::int
        WHEN 0 THEN 'Alexander'
        WHEN 1 THEN 'Maria'
        WHEN 2 THEN 'Dmitry'
        WHEN 3 THEN 'Elena'
        WHEN 4 THEN 'Sergey'
        WHEN 5 THEN 'Anna'
        WHEN 6 THEN 'Vladimir'
        WHEN 7 THEN 'Tatiana'
        WHEN 8 THEN 'Andrey'
        WHEN 9 THEN 'Olga'
        WHEN 10 THEN 'Mikhail'
        WHEN 11 THEN 'Natalia'
        WHEN 12 THEN 'Igor'
        WHEN 13 THEN 'Svetlana'
        WHEN 14 THEN 'Pavel'
        WHEN 15 THEN 'Irina'
        WHEN 16 THEN 'Alexey'
        WHEN 17 THEN 'Yulia'
        WHEN 18 THEN 'Roman'
        ELSE 'Ekaterina'
    END,
    CASE (random() * 20)::int
        WHEN 0 THEN 'Petrov'
        WHEN 1 THEN 'Ivanov'
        WHEN 2 THEN 'Sidorov'
        WHEN 3 THEN 'Kozlov'
        WHEN 4 THEN 'Novikov'
        WHEN 5 THEN 'Morozov'
        WHEN 6 THEN 'Popov'
        WHEN 7 THEN 'Volkov'
        WHEN 8 THEN 'Sokolov'
        WHEN 9 THEN 'Lebedev'
        WHEN 10 THEN 'Semenov'
        WHEN 11 THEN 'Egorov'
        WHEN 12 THEN 'Pavlov'
        WHEN 13 THEN 'Kozlova'
        WHEN 14 THEN 'Stepanov'
        WHEN 15 THEN 'Nikolaev'
        WHEN 16 THEN 'Orlov'
        WHEN 17 THEN 'Andreev'
        WHEN 18 THEN 'Makarov'
        ELSE 'Nikitin'
    END,
    'user' || gs || '@example.com',
    '+7495' || LPAD((random() * 10000000)::int::text, 7, '0'),
    '+7985' || LPAD((random() * 10000000)::int::text, 7, '0'),
    '1970-01-01'::date + (random() * 18250)::int,
    CASE (random() * 4)::int
        WHEN 0 THEN 'Male'
        WHEN 1 THEN 'Female'
        WHEN 2 THEN 'Other'
        ELSE 'Prefer not to say'
    END,
    '2020-01-01'::timestamp + (random() * 1460)::int * interval '1 day',
    '2024-01-01'::timestamp + (random() * 330)::int * interval '1 day' + (random() * 24)::int * interval '1 hour',
    CASE (random() * 4)::int
        WHEN 0 THEN 'Active'
        WHEN 1 THEN 'Inactive'
        WHEN 2 THEN 'Suspended'
        ELSE 'Pending'
    END,
    CASE (random() * 4)::int
        WHEN 0 THEN 'Individual'
        WHEN 1 THEN 'Business'
        WHEN 2 THEN 'Enterprise'
        ELSE 'VIP'
    END,
    CASE (random() * 3)::int
        WHEN 0 THEN 'en'
        WHEN 1 THEN 'ru'
        ELSE 'de'
    END,
    CASE (random() * 3)::int
        WHEN 0 THEN 'UTC'
        WHEN 1 THEN 'Europe/Moscow'
        ELSE 'Europe/Berlin'
    END,
    'https://avatar.example.com/user' || gs || '.jpg',
    'Customer notes for user ' || gs || '. Generated automatically.'
FROM generate_series(1, 8000) AS gs;

-- Generate Products data (3000 records) - Must be before orders
INSERT INTO products ("PRODUCT_CODE", "NAME", "DESCRIPTION", "CATEGORY", "SUBCATEGORY", "BRAND", "PRICE", "COST", "WEIGHT", "DIMENSIONS", "COLOR", "SIZE", "MATERIAL", "STOCK_QUANTITY", "MIN_STOCK_LEVEL", "IS_ACTIVE", "IMAGE_URL")
SELECT
    'PROD' || LPAD(gs::text, 6, '0'),
    CASE (random() * 20)::int
        WHEN 0 THEN 'Laptop Computer'
        WHEN 1 THEN 'Smartphone'
        WHEN 2 THEN 'Tablet Device'
        WHEN 3 THEN 'Wireless Headphones'
        WHEN 4 THEN 'Smart Watch'
        WHEN 5 THEN 'Gaming Mouse'
        WHEN 6 THEN 'Mechanical Keyboard'
        WHEN 7 THEN 'Monitor Display'
        WHEN 8 THEN 'USB Cable'
        WHEN 9 THEN 'Power Bank'
        WHEN 10 THEN 'Bluetooth Speaker'
        WHEN 11 THEN 'Webcam'
        WHEN 12 THEN 'External Hard Drive'
        WHEN 13 THEN 'Router'
        WHEN 14 THEN 'Printer'
        WHEN 15 THEN 'Office Chair'
        WHEN 16 THEN 'Desk Lamp'
        WHEN 17 THEN 'Coffee Mug'
        WHEN 18 THEN 'Notebook'
        ELSE 'Pen Set'
    END || ' Model ' || gs,
    'High-quality product with excellent features. Product number ' || gs || ' in our catalog.',
    CASE (random() * 8)::int
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Computers'
        WHEN 2 THEN 'Mobile Devices'
        WHEN 3 THEN 'Audio'
        WHEN 4 THEN 'Gaming'
        WHEN 5 THEN 'Office Supplies'
        WHEN 6 THEN 'Furniture'
        ELSE 'Accessories'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Premium'
        WHEN 1 THEN 'Standard'
        WHEN 2 THEN 'Budget'
        WHEN 3 THEN 'Professional'
        ELSE 'Consumer'
    END,
    CASE (random() * 10)::int
        WHEN 0 THEN 'Apple'
        WHEN 1 THEN 'Samsung'
        WHEN 2 THEN 'Sony'
        WHEN 3 THEN 'LG'
        WHEN 4 THEN 'HP'
        WHEN 5 THEN 'Dell'
        WHEN 6 THEN 'Lenovo'
        WHEN 7 THEN 'Asus'
        WHEN 8 THEN 'Logitech'
        ELSE 'Microsoft'
    END,
    (random() * 50000 + 100)::decimal(10,2),
    (random() * 30000 + 50)::decimal(10,2),
    (random() * 5 + 0.1)::decimal(8,3),
    (10 + random() * 90)::int || 'x' || (10 + random() * 90)::int || 'x' || (1 + random() * 20)::int || ' cm',
    CASE (random() * 8)::int
        WHEN 0 THEN 'Black'
        WHEN 1 THEN 'White'
        WHEN 2 THEN 'Silver'
        WHEN 3 THEN 'Gray'
        WHEN 4 THEN 'Blue'
        WHEN 5 THEN 'Red'
        WHEN 6 THEN 'Green'
        ELSE 'Gold'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Small'
        WHEN 1 THEN 'Medium'
        WHEN 2 THEN 'Large'
        WHEN 3 THEN 'XL'
        ELSE 'Universal'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Plastic'
        WHEN 1 THEN 'Metal'
        WHEN 2 THEN 'Glass'
        WHEN 3 THEN 'Composite'
        ELSE 'Carbon Fiber'
    END,
    (random() * 1000)::int,
    (random() * 50)::int + 5,
    random() < 0.9,
    'https://images.example.com/product' || gs || '.jpg'
FROM generate_series(1, 3000) AS gs;

-- Now generate dependent tables
-- Generate Customer-Company relationships (2000 records)
INSERT INTO customer_companies ("CUSTOMER_ID", "COMPANY_ID", "ROLE", "START_DATE", "END_DATE", "IS_PRIMARY")
SELECT
    (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
    (SELECT "ID" FROM companies ORDER BY random() LIMIT 1),
    CASE (random() * 5)::int
        WHEN 0 THEN 'Employee'
        WHEN 1 THEN 'Manager'
        WHEN 2 THEN 'Director'
        WHEN 3 THEN 'Consultant'
        ELSE 'Partner'
    END,
    '2020-01-01'::date + (random() * 1460)::int,
    CASE WHEN random() < 0.7 THEN NULL ELSE '2020-01-01'::date + (random() * 1460)::int + 365 END,
    random() < 0.8
FROM generate_series(1, 2000) AS gs;

-- Generate Addresses data (12000 records)
INSERT INTO addresses ("CUSTOMER_ID", "COMPANY_ID", "ADDRESS_TYPE", "STREET_ADDRESS", "APARTMENT", "CITY", "STATE_PROVINCE", "POSTAL_CODE", "COUNTRY", "LATITUDE", "LONGITUDE", "IS_DEFAULT")
SELECT
    CASE WHEN random() < 0.7 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.3 THEN (SELECT "ID" FROM companies ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Home'
        WHEN 1 THEN 'Work'
        WHEN 2 THEN 'Billing'
        WHEN 3 THEN 'Shipping'
        ELSE 'Other'
    END,
    CASE (random() * 20)::int
        WHEN 0 THEN 'Tverskaya Street'
        WHEN 1 THEN 'Nevsky Prospect'
        WHEN 2 THEN 'Arbat Street'
        WHEN 3 THEN 'Red Square'
        WHEN 4 THEN 'Leninsky Prospect'
        WHEN 5 THEN 'Kutuzovsky Prospect'
        WHEN 6 THEN 'Sadovoe Ring'
        WHEN 7 THEN 'Sokolnicheskoye Highway'
        WHEN 8 THEN 'Volokolamskoe Highway'
        WHEN 9 THEN 'Kashirskoe Highway'
        WHEN 10 THEN 'Leningradsky Prospect'
        WHEN 11 THEN 'Varshavskoe Highway'
        WHEN 12 THEN 'Ryazansky Prospect'
        WHEN 13 THEN 'Altufevskoe Highway'
        WHEN 14 THEN 'Dmitrovskoe Highway'
        WHEN 15 THEN 'Yaroslavskoe Highway'
        WHEN 16 THEN 'Schelkovskoe Highway'
        WHEN 17 THEN 'Entuziastov Highway'
        WHEN 18 THEN 'Volgogradsky Prospect'
        ELSE 'Mira Prospect'
    END || ', ' || (random() * 200 + 1)::int,
    CASE WHEN random() < 0.6 THEN (random() * 300 + 1)::int::text ELSE NULL END,
    CASE (random() * 10)::int
        WHEN 0 THEN 'Moscow'
        WHEN 1 THEN 'Saint Petersburg'
        WHEN 2 THEN 'Novosibirsk'
        WHEN 3 THEN 'Yekaterinburg'
        WHEN 4 THEN 'Nizhny Novgorod'
        WHEN 5 THEN 'Kazan'
        WHEN 6 THEN 'Chelyabinsk'
        WHEN 7 THEN 'Omsk'
        WHEN 8 THEN 'Samara'
        ELSE 'Rostov-on-Don'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Moscow Oblast'
        WHEN 1 THEN 'Leningrad Oblast'
        WHEN 2 THEN 'Novosibirsk Oblast'
        WHEN 3 THEN 'Sverdlovsk Oblast'
        ELSE 'Nizhny Novgorod Oblast'
    END,
    LPAD((random() * 999999)::int::text, 6, '0'),
    'Russia',
    55.7558 + (random() - 0.5) * 10,
    37.6176 + (random() - 0.5) * 10,
    random() < 0.3
FROM generate_series(1, 12000) AS gs;

-- Generate Orders data (15000 records) - Must be after customers and addresses
INSERT INTO orders ("ORDER_NUMBER", "CUSTOMER_ID", "ORDER_DATE", "STATUS", "PAYMENT_METHOD", "PAYMENT_STATUS", "SUBTOTAL", "TAX_AMOUNT", "SHIPPING_AMOUNT", "DISCOUNT_AMOUNT", "TOTAL_AMOUNT", "CURRENCY", "SHIPPING_ADDRESS_ID", "BILLING_ADDRESS_ID", "NOTES", "TRACKING_NUMBER", "SHIPPED_DATE", "DELIVERED_DATE")
SELECT
    'ORDER' || LPAD(gs::text, 8, '0'),
    (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
    '2023-01-01'::timestamp + (random() * 700)::int * interval '1 day' + (random() * 24)::int * interval '1 hour',
    CASE (random() * 6)::int
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Processing'
        WHEN 2 THEN 'Shipped'
        WHEN 3 THEN 'Delivered'
        WHEN 4 THEN 'Cancelled'
        ELSE 'Refunded'
    END,
    CASE (random() * 6)::int
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'Debit Card'
        WHEN 2 THEN 'PayPal'
        WHEN 3 THEN 'Bank Transfer'
        WHEN 4 THEN 'Cash'
        ELSE 'Crypto'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Paid'
        WHEN 2 THEN 'Failed'
        WHEN 3 THEN 'Refunded'
        ELSE 'Partially Refunded'
    END,
    (random() * 100000 + 500)::decimal(10,2),
    (random() * 20000)::decimal(10,2),
    (random() * 5000)::decimal(10,2),
    (random() * 10000)::decimal(10,2),
    (random() * 120000 + 500)::decimal(10,2),
    'RUB',
    (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
    (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
    'Order notes for order ' || gs || '. Automatically generated.',
    CASE WHEN random() < 0.7 THEN 'TRACK' || LPAD((random() * 999999999)::bigint::text, 12, '0') ELSE NULL END,
    CASE WHEN random() < 0.6 THEN '2023-01-01'::timestamp + (random() * 700)::int * interval '1 day' + 1 * interval 'day' ELSE NULL END,
    CASE WHEN random() < 0.5 THEN '2023-01-01'::timestamp + (random() * 700)::int * interval '1 day' + 5 * interval 'day' ELSE NULL END
FROM generate_series(1, 15000) AS gs;

-- Generate Order Items data (45000 records - average 3 items per order)
INSERT INTO order_items ("ORDER_ID", "PRODUCT_ID", "QUANTITY", "UNIT_PRICE", "TOTAL_PRICE", "DISCOUNT_AMOUNT")
SELECT
    (SELECT "ID" FROM orders ORDER BY random() LIMIT 1),
    (SELECT "ID" FROM products ORDER BY random() LIMIT 1),
    (random() * 5)::int + 1,
    (random() * 50000 + 100)::decimal(10,2),
    (random() * 5 + 1)::int * (random() * 50000 + 100)::decimal(10,2),
    (random() * 5000)::decimal(10,2)
FROM generate_series(1, 45000) AS gs;

-- Generate Leads data (5000 records) - Must be before deals
INSERT INTO leads ("LEAD_CODE", "FIRST_NAME", "LAST_NAME", "COMPANY_NAME", "EMAIL", "PHONE", "SOURCE", "STATUS", "SCORE", "ASSIGNED_TO", "NOTES", "CONVERSION_DATE", "CONVERTED_CUSTOMER_ID")
SELECT
    'LEAD' || LPAD(gs::text, 6, '0'),
    CASE (random() * 15)::int
        WHEN 0 THEN 'Ivan'
        WHEN 1 THEN 'Maria'
        WHEN 2 THEN 'Alexander'
        WHEN 3 THEN 'Elena'
        WHEN 4 THEN 'Dmitry'
        WHEN 5 THEN 'Anna'
        WHEN 6 THEN 'Sergey'
        WHEN 7 THEN 'Olga'
        WHEN 8 THEN 'Pavel'
        WHEN 9 THEN 'Natalia'
        WHEN 10 THEN 'Andrey'
        WHEN 11 THEN 'Svetlana'
        WHEN 12 THEN 'Igor'
        WHEN 13 THEN 'Irina'
        ELSE 'Mikhail'
    END,
    CASE (random() * 15)::int
        WHEN 0 THEN 'Petrov'
        WHEN 1 THEN 'Ivanov'
        WHEN 2 THEN 'Sidorov'
        WHEN 3 THEN 'Kozlov'
        WHEN 4 THEN 'Novikov'
        WHEN 5 THEN 'Morozov'
        WHEN 6 THEN 'Popov'
        WHEN 7 THEN 'Volkov'
        WHEN 8 THEN 'Sokolov'
        WHEN 9 THEN 'Lebedev'
        WHEN 10 THEN 'Semenov'
        WHEN 11 THEN 'Egorov'
        WHEN 12 THEN 'Pavlov'
        WHEN 13 THEN 'Stepanov'
        ELSE 'Nikolaev'
    END,
    'Prospect Company ' || gs || ' Ltd',
    'lead' || gs || '@prospect.com',
    '+7495' || LPAD((random() * 10000000)::int::text, 7, '0'),
    CASE (random() * 8)::int
        WHEN 0 THEN 'Website'
        WHEN 1 THEN 'Social Media'
        WHEN 2 THEN 'Email Marketing'
        WHEN 3 THEN 'Referral'
        WHEN 4 THEN 'Trade Show'
        WHEN 5 THEN 'Cold Call'
        WHEN 6 THEN 'Advertisement'
        ELSE 'Partner'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'New'
        WHEN 1 THEN 'Contacted'
        WHEN 2 THEN 'Qualified'
        WHEN 3 THEN 'Disqualified'
        ELSE 'Converted'
    END,
    (random() * 100)::int,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Sales Rep 1'
        WHEN 1 THEN 'Sales Rep 2'
        WHEN 2 THEN 'Sales Rep 3'
        WHEN 3 THEN 'Sales Rep 4'
        ELSE 'Sales Manager'
    END,
    'Lead notes for prospect ' || gs || '. Generated automatically.',
    CASE WHEN random() < 0.2 THEN '2024-01-01'::timestamp + (random() * 330)::int * interval '1 day' ELSE NULL END,
    CASE WHEN random() < 0.2 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) ELSE NULL END
FROM generate_series(1, 5000) AS gs;

-- Generate Deals data (3000 records)
INSERT INTO deals ("DEAL_NAME", "CUSTOMER_ID", "LEAD_ID", "STAGE", "VALUE", "CURRENCY", "PROBABILITY", "EXPECTED_CLOSE_DATE", "ACTUAL_CLOSE_DATE", "ASSIGNED_TO", "NOTES")
SELECT
    'Deal ' || gs || ' - ' ||
    CASE (random() * 8)::int
        WHEN 0 THEN 'Software License'
        WHEN 1 THEN 'Hardware Purchase'
        WHEN 2 THEN 'Consulting Services'
        WHEN 3 THEN 'Support Contract'
        WHEN 4 THEN 'Training Package'
        WHEN 5 THEN 'Integration Project'
        WHEN 6 THEN 'Maintenance Agreement'
        ELSE 'Custom Solution'
    END,
    CASE WHEN random() < 0.8 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.4 THEN (SELECT "ID" FROM leads ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE (random() * 6)::int
        WHEN 0 THEN 'Prospecting'
        WHEN 1 THEN 'Qualification'
        WHEN 2 THEN 'Proposal'
        WHEN 3 THEN 'Negotiation'
        WHEN 4 THEN 'Closed Won'
        ELSE 'Closed Lost'
    END,
    (random() * 5000000 + 10000)::decimal(12,2),
    'RUB',
    (random() * 100)::int,
    '2024-01-01'::date + (random() * 365)::int,
    CASE WHEN random() < 0.3 THEN '2024-01-01'::date + (random() * 300)::int ELSE NULL END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Sales Rep 1'
        WHEN 1 THEN 'Sales Rep 2'
        WHEN 2 THEN 'Sales Rep 3'
        WHEN 3 THEN 'Sales Rep 4'
        ELSE 'Sales Manager'
    END,
    'Deal notes for deal ' || gs || '. Generated automatically.'
FROM generate_series(1, 3000) AS gs;

-- Generate Tasks data (10000 records)
INSERT INTO tasks ("TITLE", "DESCRIPTION", "CUSTOMER_ID", "LEAD_ID", "DEAL_ID", "ASSIGNED_TO", "STATUS", "PRIORITY", "DUE_DATE", "COMPLETED_DATE", "ESTIMATED_HOURS", "ACTUAL_HOURS")
SELECT
    CASE (random() * 10)::int
        WHEN 0 THEN 'Follow up call'
        WHEN 1 THEN 'Send proposal'
        WHEN 2 THEN 'Product demonstration'
        WHEN 3 THEN 'Meeting setup'
        WHEN 4 THEN 'Contract review'
        WHEN 5 THEN 'Technical consultation'
        WHEN 6 THEN 'Price negotiation'
        WHEN 7 THEN 'Document preparation'
        WHEN 8 THEN 'Client presentation'
        ELSE 'Project planning'
    END || ' for ' || gs,
    'Task description for task number ' || gs || '. This task needs to be completed according to schedule.',
    CASE WHEN random() < 0.6 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.3 THEN (SELECT "ID" FROM leads ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.4 THEN (SELECT "ID" FROM deals ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE (random() * 8)::int
        WHEN 0 THEN 'Sales Rep 1'
        WHEN 1 THEN 'Sales Rep 2'
        WHEN 2 THEN 'Sales Rep 3'
        WHEN 3 THEN 'Sales Manager'
        WHEN 4 THEN 'Account Manager'
        WHEN 5 THEN 'Technical Lead'
        WHEN 6 THEN 'Project Manager'
        ELSE 'Support Specialist'
    END,
    CASE (random() * 4)::int
        WHEN 0 THEN 'Not Started'
        WHEN 1 THEN 'In Progress'
        WHEN 2 THEN 'Completed'
        ELSE 'Deferred'
    END,
    CASE (random() * 4)::int
        WHEN 0 THEN 'Low'
        WHEN 1 THEN 'Medium'
        WHEN 2 THEN 'High'
        ELSE 'Critical'
    END,
    '2024-01-01'::timestamp + (random() * 365)::int * interval '1 day' + (random() * 24)::int * interval '1 hour',
    CASE WHEN random() < 0.4 THEN '2024-01-01'::timestamp + (random() * 300)::int * interval '1 day' ELSE NULL END,
    (random() * 40 + 1)::decimal(5,2),
    CASE WHEN random() < 0.4 THEN (random() * 50 + 0.5)::decimal(5,2) ELSE NULL END
FROM generate_series(1, 10000) AS gs;

-- Generate Invoices data (8000 records)
INSERT INTO invoices ("INVOICE_NUMBER", "CUSTOMER_ID", "ORDER_ID", "DEAL_ID", "INVOICE_DATE", "DUE_DATE", "STATUS", "SUBTOTAL", "TAX_RATE", "TAX_AMOUNT", "DISCOUNT_AMOUNT", "TOTAL_AMOUNT", "CURRENCY", "NOTES", "PAYMENT_DATE")
SELECT
    'INV' || gs || '/' || EXTRACT(YEAR FROM CURRENT_DATE),
    (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
    CASE WHEN random() < 0.7 THEN (SELECT "ID" FROM orders ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.3 THEN (SELECT "ID" FROM deals ORDER BY random() LIMIT 1) ELSE NULL END,
    '2024-01-01'::date + (random() * 330)::int,
    '2024-01-01'::date + (random() * 330)::int + 30,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Draft'
        WHEN 1 THEN 'Sent'
        WHEN 2 THEN 'Paid'
        WHEN 3 THEN 'Overdue'
        ELSE 'Cancelled'
    END,
    (random() * 500000 + 1000)::decimal(12,2),
    20.0,
    (random() * 100000 + 200)::decimal(12,2),
    (random() * 50000)::decimal(12,2),
    (random() * 600000 + 1200)::decimal(12,2),
    'RUB',
    'Invoice notes for invoice ' || gs || '. Payment terms: 30 days.',
    CASE WHEN random() < 0.6 THEN '2024-01-01'::date + (random() * 300)::int ELSE NULL END
FROM generate_series(1, 8000) AS gs;

-- Generate Deliveries data (12000 records)
INSERT INTO deliveries ("DELIVERY_NUMBER", "ORDER_ID", "CARRIER", "TRACKING_NUMBER", "STATUS", "SHIPPING_DATE", "EXPECTED_DELIVERY_DATE", "ACTUAL_DELIVERY_DATE", "DELIVERY_ADDRESS_ID", "RECIPIENT_NAME", "RECIPIENT_PHONE", "NOTES")
SELECT
    'DEL' || LPAD(gs::text, 8, '0'),
    (SELECT "ID" FROM orders ORDER BY random() LIMIT 1),
    CASE (random() * 6)::int
        WHEN 0 THEN 'Russian Post'
        WHEN 1 THEN 'CDEK'
        WHEN 2 THEN 'Boxberry'
        WHEN 3 THEN 'Pochta Express'
        WHEN 4 THEN 'DHL'
        ELSE 'FedEx'
    END,
    'TRACK' || LPAD((random() * 999999999)::bigint::text, 12, '0'),
    CASE (random() * 5)::int
        WHEN 0 THEN 'Preparing'
        WHEN 1 THEN 'Shipped'
        WHEN 2 THEN 'In Transit'
        WHEN 3 THEN 'Delivered'
        ELSE 'Failed'
    END,
    '2024-01-01'::timestamp + (random() * 330)::int * interval '1 day',
    '2024-01-01'::timestamp + (random() * 330)::int * interval '1 day' + (random() * 10 + 1)::int * interval '1 day',
    CASE WHEN random() < 0.7 THEN '2024-01-01'::timestamp + (random() * 330)::int * interval '1 day' + (random() * 12 + 1)::int * interval '1 day' ELSE NULL END,
    (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
    CASE (random() * 15)::int
        WHEN 0 THEN 'Ivan Petrov'
        WHEN 1 THEN 'Maria Ivanova'
        WHEN 2 THEN 'Alexander Sidorov'
        WHEN 3 THEN 'Elena Kozlova'
        WHEN 4 THEN 'Dmitry Novikov'
        WHEN 5 THEN 'Anna Morozova'
        WHEN 6 THEN 'Sergey Popov'
        WHEN 7 THEN 'Olga Volkova'
        WHEN 8 THEN 'Pavel Sokolov'
        WHEN 9 THEN 'Natalia Lebedeva'
        WHEN 10 THEN 'Andrey Semenov'
        WHEN 11 THEN 'Svetlana Egorova'
        WHEN 12 THEN 'Igor Pavlov'
        WHEN 13 THEN 'Irina Stepanova'
        ELSE 'Mikhail Nikolaev'
    END,
    '+7495' || LPAD((random() * 10000000)::int::text, 7, '0'),
    'Delivery notes for delivery ' || gs || '. Handle with care.'
FROM generate_series(1, 12000) AS gs;

-- Update sequences to correct values
SELECT setval('customers_id_seq', COALESCE((SELECT MAX("ID") FROM customers), 1));
SELECT setval('companies_id_seq', COALESCE((SELECT MAX("ID") FROM companies), 1));
SELECT setval('customer_companies_id_seq', COALESCE((SELECT MAX("ID") FROM customer_companies), 1));
SELECT setval('addresses_id_seq', COALESCE((SELECT MAX("ID") FROM addresses), 1));
SELECT setval('products_id_seq', COALESCE((SELECT MAX("ID") FROM products), 1));
SELECT setval('orders_id_seq', COALESCE((SELECT MAX("ID") FROM orders), 1));
SELECT setval('order_items_id_seq', COALESCE((SELECT MAX("ID") FROM order_items), 1));
SELECT setval('leads_id_seq', COALESCE((SELECT MAX("ID") FROM leads), 1));
SELECT setval('deals_id_seq', COALESCE((SELECT MAX("ID") FROM deals), 1));
SELECT setval('tasks_id_seq', COALESCE((SELECT MAX("ID") FROM tasks), 1));
SELECT setval('invoices_id_seq', COALESCE((SELECT MAX("ID") FROM invoices), 1));
SELECT setval('deliveries_id_seq', COALESCE((SELECT MAX("ID") FROM deliveries), 1));

-- Fallback generation to ensure orders and invoices are populated if empty
DO $$
DECLARE ord_cnt INT; inv_cnt INT; cust_cnt INT; addr_cnt INT; deal_cnt INT; BEGIN
    SELECT COUNT(*) INTO ord_cnt FROM orders;
    IF ord_cnt = 0 THEN
        SELECT COUNT(*) INTO cust_cnt FROM customers;
        SELECT COUNT(*) INTO addr_cnt FROM addresses;
        -- Generate 2000 orders as fallback
        INSERT INTO orders ("ORDER_NUMBER", "CUSTOMER_ID", "ORDER_DATE", "STATUS", "PAYMENT_METHOD", "PAYMENT_STATUS", "SUBTOTAL", "TAX_AMOUNT", "SHIPPING_AMOUNT", "DISCOUNT_AMOUNT", "TOTAL_AMOUNT", "CURRENCY", "SHIPPING_ADDRESS_ID", "BILLING_ADDRESS_ID", "NOTES")
        SELECT
            'ORDERFB' || LPAD(gs::text, 8, '0'),
            (SELECT "ID" FROM customers OFFSET floor(random() * cust_cnt) LIMIT 1),
            CURRENT_TIMESTAMP - (floor(random()*365)) * interval '1 day',
            (ARRAY['Pending','Processing','Shipped','Delivered','Cancelled','Refunded'])[1 + floor(random()*6)::int],
            (ARRAY['Credit Card','Debit Card','PayPal','Bank Transfer','Cash','Crypto'])[1 + floor(random()*6)::int],
            (ARRAY['Pending','Paid','Failed','Refunded','Partially Refunded'])[1 + floor(random()*5)::int],
            round((random()*5000+50)::numeric,2),
            round((random()*1000)::numeric,2),
            round((random()*500)::numeric,2),
            round((random()*300)::numeric,2),
            round((random()*7000+50)::numeric,2),
            'RUB',
            CASE WHEN addr_cnt > 0 THEN (SELECT "ID" FROM addresses OFFSET floor(random()*addr_cnt) LIMIT 1) END,
            CASE WHEN addr_cnt > 0 THEN (SELECT "ID" FROM addresses OFFSET floor(random()*addr_cnt) LIMIT 1) END,
            'Fallback generated order #' || gs
        FROM generate_series(1,2000) AS gs;
    END IF;

    SELECT COUNT(*) INTO inv_cnt FROM invoices;
    IF inv_cnt = 0 THEN
        SELECT COUNT(*) INTO deal_cnt FROM deals;
        SELECT COUNT(*) INTO ord_cnt FROM orders; -- refresh after possible fallback
        -- Generate 3000 invoices as fallback
        INSERT INTO invoices ("INVOICE_NUMBER", "CUSTOMER_ID", "ORDER_ID", "DEAL_ID", "INVOICE_DATE", "DUE_DATE", "STATUS", "SUBTOTAL", "TAX_RATE", "TAX_AMOUNT", "DISCOUNT_AMOUNT", "TOTAL_AMOUNT", "CURRENCY", "NOTES")
        SELECT
            'INVFB' || gs || '/' || EXTRACT(YEAR FROM CURRENT_DATE),
            (SELECT "ID" FROM customers OFFSET floor(random() * (SELECT COUNT(*) FROM customers)) LIMIT 1),
            CASE WHEN ord_cnt > 0 AND random() < 0.7 THEN (SELECT "ID" FROM orders OFFSET floor(random()*ord_cnt) LIMIT 1) END,
            CASE WHEN deal_cnt > 0 AND random() < 0.3 THEN (SELECT "ID" FROM deals OFFSET floor(random()*deal_cnt) LIMIT 1) END,
            CURRENT_DATE - (floor(random()*180))::int,
            (CURRENT_DATE - (floor(random()*180))::int) + 30,
            (ARRAY['Draft','Sent','Paid','Overdue','Cancelled'])[1 + floor(random()*5)::int],
            round((random()*20000+500)::numeric,2),
            20.0,
            round((random()*4000+100)::numeric,2),
            round((random()*2000)::numeric,2),
            round((random()*25000+600)::numeric,2),
            'RUB',
            'Fallback generated invoice #' || gs
        FROM generate_series(1,3000) AS gs;
    END IF;
END$$;
