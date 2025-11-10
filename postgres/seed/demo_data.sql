-- Demo seed data aligned with current PostgreSQL schema
-- Table names: lowercase, Field names: UPPERCASE (quoted)
-- Generates thousands of records for comprehensive testing

SET client_encoding = 'UTF8';
SET timezone = 'UTC';

-- Generate Companies data (20 records)
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
FROM generate_series(1, 20) AS gs;

-- Generate Customers data (80 records)
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
FROM generate_series(1, 80) AS gs;

-- Generate Customer-Company relationships (20 records)
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
FROM generate_series(1, 20) AS gs;

-- Generate Addresses data (120 records)
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
FROM generate_series(1, 120) AS gs;

-- Generate Products data (50 records)
INSERT INTO products ("PRODUCT_CODE", "NAME", "DESCRIPTION", "CATEGORY", "SUBCATEGORY", "BRAND", "PRICE", "COST", "WEIGHT", "DIMENSIONS", "COLOR", "SIZE", "MATERIAL", "STOCK_QUANTITY", "MIN_STOCK_LEVEL", "IS_ACTIVE", "IMAGE_URL")
SELECT
    'PROD' || LPAD(gs::text, 6, '0'),
    'Product ' || gs,
    'Description for product ' || gs,
    CASE (random() * 8)::int
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Clothing'
        WHEN 2 THEN 'Books'
        WHEN 3 THEN 'Home & Garden'
        WHEN 4 THEN 'Sports'
        WHEN 5 THEN 'Toys'
        WHEN 6 THEN 'Beauty'
        ELSE 'Automotive'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Subcategory A'
        WHEN 1 THEN 'Subcategory B'
        WHEN 2 THEN 'Subcategory C'
        WHEN 3 THEN 'Subcategory D'
        ELSE 'Subcategory E'
    END,
    CASE (random() * 10)::int
        WHEN 0 THEN 'Brand A'
        WHEN 1 THEN 'Brand B'
        WHEN 2 THEN 'Brand C'
        WHEN 3 THEN 'Brand D'
        WHEN 4 THEN 'Brand E'
        WHEN 5 THEN 'Brand F'
        WHEN 6 THEN 'Brand G'
        WHEN 7 THEN 'Brand H'
        WHEN 8 THEN 'Brand I'
        ELSE 'Brand J'
    END,
    (random() * 1000 + 10)::decimal(10,2),
    (random() * 500 + 5)::decimal(10,2),
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
FROM generate_series(1, 50) AS gs;

-- Generate Orders data (150 records)
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
    CASE WHEN random() < 0.6 THEN '2023-01-01'::timestamp + (random() * 700)::int * interval '1 day' + interval '1 day' ELSE NULL END,
    CASE WHEN random() < 0.5 THEN '2023-01-01'::timestamp + (random() * 700)::int * interval '1 day' + interval '5 day' ELSE NULL END
FROM generate_series(1, 150) AS gs;

-- Generate Order Items data (450 records)
INSERT INTO order_items ("ORDER_ID", "PRODUCT_ID", "QUANTITY", "UNIT_PRICE", "TOTAL_PRICE", "DISCOUNT_AMOUNT")
SELECT
    (SELECT "ID" FROM orders ORDER BY random() LIMIT 1),
    (SELECT "ID" FROM products ORDER BY random() LIMIT 1),
    (random() * 5)::int + 1,
    (random() * 50000 + 100)::decimal(10,2),
    ((random() * 5 + 1)::int * (random() * 50000 + 100))::decimal(10,2),
    (random() * 5000)::decimal(10,2)
FROM generate_series(1, 450) AS gs;

-- Generate Leads data (50 records)
INSERT INTO leads ("LEAD_CODE", "FIRST_NAME", "LAST_NAME", "COMPANY_NAME", "EMAIL", "PHONE", "SOURCE", "STATUS", "SCORE", "ASSIGNED_TO", "NOTES")
SELECT
    'LEAD' || LPAD(gs::text, 6, '0'),
    'Lead' || gs,
    'Prospect' || gs,
    'Prospect Company ' || gs,
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
    'Sales Rep ' || ((random() * 5)::int + 1),
    'Lead notes for prospect ' || gs
FROM generate_series(1, 50) AS gs;

-- Generate Deals data (30 records)
INSERT INTO deals ("DEAL_NAME", "CUSTOMER_ID", "LEAD_ID", "STAGE", "VALUE", "CURRENCY", "PROBABILITY", "EXPECTED_CLOSE_DATE", "ACTUAL_CLOSE_DATE", "ASSIGNED_TO", "NOTES")
SELECT
    'Deal ' || gs || ' - ' || CASE (random() * 5)::int
        WHEN 0 THEN 'Software License'
        WHEN 1 THEN 'Consulting'
        WHEN 2 THEN 'Hardware'
        WHEN 3 THEN 'Support'
        ELSE 'Training'
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
FROM generate_series(1, 30) AS gs;

-- Generate Tasks data (100 records)
INSERT INTO tasks ("TITLE", "DESCRIPTION", "CUSTOMER_ID", "LEAD_ID", "DEAL_ID", "ASSIGNED_TO", "STATUS", "PRIORITY", "DUE_DATE", "COMPLETED_DATE", "ESTIMATED_HOURS", "ACTUAL_HOURS")
SELECT
    'Task ' || gs || ' - ' || CASE (random() * 5)::int
        WHEN 0 THEN 'Follow up'
        WHEN 1 THEN 'Meeting'
        WHEN 2 THEN 'Proposal'
        WHEN 3 THEN 'Review'
        ELSE 'Analysis'
    END,
    'Task description for task number ' || gs,
    CASE WHEN random() < 0.6 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.3 THEN (SELECT "ID" FROM leads ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() < 0.4 THEN (SELECT "ID" FROM deals ORDER BY random() LIMIT 1) ELSE NULL END,
    'Sales Rep ' || ((random() * 5)::int + 1),
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
FROM generate_series(1, 100) AS gs;

-- Generate Invoices data (80 records)
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
FROM generate_series(1, 80) AS gs;

-- Generate Deliveries data (120 records)
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
    'Recipient ' || gs,
    '+7495' || LPAD((random() * 10000000)::int::text, 7, '0'),
    'Delivery notes for delivery ' || gs
FROM generate_series(1, 120) AS gs;

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

