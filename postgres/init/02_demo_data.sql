-- Generate comprehensive demo data for PostgreSQL

-- Generate Customers (8000 records)
INSERT INTO customers (CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE, DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE)
SELECT
    'CUST' || LPAD(i::text, 6, '0'),
    'FirstName' || i,
    'LastName' || i,
    'customer' || i || '@example.com',
    '123-456-' || LPAD(i::text, 4, '0'),
    '987-654-' || LPAD(i::text, 4, '0'),
    CURRENT_DATE - (18 + floor(random() * 50)) * interval '1 year',
    (ARRAY['Male', 'Female', 'Other', 'Prefer not to say'])[floor(random() * 4) + 1]::GENDER_TYPE,
    (ARRAY['Active', 'Inactive', 'Suspended', 'Pending'])[floor(random() * 4) + 1]::CUSTOMER_STATUS_TYPE,
    (ARRAY['Individual', 'Business', 'Enterprise', 'VIP'])[floor(random() * 4) + 1]::CUSTOMER_TYPE_ENUM
FROM generate_series(1, 8000) AS i;

-- Generate Companies (2000 records)
INSERT INTO companies (COMPANY_NAME, INDUSTRY, COMPANY_SIZE, ANNUAL_REVENUE, EMPLOYEE_COUNT, WEBSITE, FOUNDED_YEAR)
SELECT
    'Company ' || i || ' Ltd',
    (ARRAY['Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing', 'Education', 'Construction', 'Transportation', 'Energy', 'Media'])[floor(random() * 10) + 1],
    (ARRAY['Startup', 'Small', 'Medium', 'Large', 'Enterprise'])[floor(random() * 5) + 1]::COMPANY_SIZE_TYPE,
    round((random() * 50000000)::numeric, 2),
    floor(random() * 10000) + 1,
    'https://www.company' || i || '.com',
    1950 + floor(random() * 73)
FROM generate_series(1, 2000) AS i;

-- Generate Products (5000 records)
INSERT INTO products (PRODUCT_CODE, NAME, DESCRIPTION, CATEGORY, SUBCATEGORY, BRAND, PRICE, COST, STOCK_QUANTITY, MIN_STOCK_LEVEL, IS_ACTIVE)
SELECT
    'PROD' || LPAD(i::text, 6, '0'),
    'Product ' || i,
    'Description for product ' || i,
    (ARRAY['Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports', 'Toys', 'Beauty', 'Automotive'])[floor(random() * 8) + 1],
    (ARRAY['Subcategory A', 'Subcategory B', 'Subcategory C', 'Subcategory D', 'Subcategory E'])[floor(random() * 5) + 1],
    (ARRAY['Brand A', 'Brand B', 'Brand C', 'Brand D', 'Brand E', 'Brand F', 'Brand G', 'Brand H', 'Brand I', 'Brand J'])[floor(random() * 10) + 1],
    round((random() * 1000 + 10)::numeric, 2),
    round((random() * 500 + 5)::numeric, 2),
    floor(random() * 1000),
    floor(random() * 50),
    CASE WHEN random() > 0.1 THEN true ELSE false END
FROM generate_series(1, 5000) AS i;

-- Generate Addresses (12000 records)
INSERT INTO addresses (CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT)
SELECT
    (SELECT ID FROM customers ORDER BY random() LIMIT 1),
    (ARRAY['Home', 'Work', 'Billing', 'Shipping', 'Other'])[floor(random() * 5) + 1]::ADDRESS_TYPE,
    'Street ' || i || ', Building ' || (floor(random() * 100) + 1),
    (ARRAY['Moscow', 'St. Petersburg', 'Novosibirsk', 'Yekaterinburg', 'Nizhny Novgorod', 'Kazan', 'Chelyabinsk', 'Omsk', 'Samara', 'Rostov-on-Don', 'Ufa', 'Krasnoyarsk', 'Voronezh', 'Perm', 'Volgograd', 'Krasnodar', 'Saratov', 'Tyumen', 'Tolyatti', 'Izhevsk'])[floor(random() * 20) + 1],
    (ARRAY['Moscow Region', 'Leningrad Region', 'Sverdlovsk Region', 'Tatarstan', 'Bashkortostan', 'Chelyabinsk Region', 'Novosibirsk Region', 'Samara Region', 'Krasnoyarsk Region', 'Rostov Region'])[floor(random() * 10) + 1],
    LPAD((floor(random() * 900000) + 100000)::text, 6, '0'),
    'Russia',
    CASE WHEN i % 3 = 0 THEN true ELSE false END
FROM generate_series(1, 12000) AS i;

-- Generate Orders (15000 records)
INSERT INTO orders (ORDER_NUMBER, CUSTOMER_ID, STATUS, PAYMENT_METHOD, PAYMENT_STATUS, SUBTOTAL, TAX_AMOUNT, SHIPPING_AMOUNT, DISCOUNT_AMOUNT, TOTAL_AMOUNT, ORDER_DATE)
SELECT
    'ORD' || LPAD(i::text, 8, '0'),
    (SELECT ID FROM customers ORDER BY random() LIMIT 1),
    (ARRAY['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded'])[floor(random() * 6) + 1]::ORDER_STATUS_TYPE,
    (ARRAY['Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash', 'Crypto'])[floor(random() * 6) + 1]::PAYMENT_METHOD_TYPE,
    (ARRAY['Pending', 'Paid', 'Failed', 'Refunded', 'Partially Refunded'])[floor(random() * 5) + 1]::PAYMENT_STATUS_TYPE,
    round((random() * 5000 + 50)::numeric, 2),
    round(((random() * 5000 + 50) * 0.2)::numeric, 2),
    round((random() * 100 + 10)::numeric, 2),
    round((random() * 200)::numeric, 2),
    round(((random() * 5000 + 50) + (random() * 5000 + 50) * 0.2 + (random() * 100 + 10) - (random() * 200))::numeric, 2),
    CURRENT_TIMESTAMP - (floor(random() * 365)) * interval '1 day'
FROM generate_series(1, 15000) AS i;

-- Generate Order Items (35000 records)
INSERT INTO order_items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, TOTAL_PRICE, DISCOUNT_AMOUNT)
SELECT
    (SELECT ID FROM orders ORDER BY random() LIMIT 1),
    products.ID,
    floor(random() * 5) + 1,
    products.PRICE,
    products.PRICE * (floor(random() * 5) + 1),
    round((random() * 50)::numeric, 2)
FROM generate_series(1, 35000) AS i
CROSS JOIN LATERAL (SELECT ID, PRICE FROM products ORDER BY random() LIMIT 1) AS products;

-- Generate Leads (6000 records)
INSERT INTO leads (LEAD_CODE, FIRST_NAME, LAST_NAME, COMPANY_NAME, EMAIL, PHONE, SOURCE, STATUS, SCORE, ASSIGNED_TO)
SELECT
    'LEAD' || LPAD(i::text, 6, '0'),
    'LeadFirst' || i,
    'LeadLast' || i,
    'Lead Company ' || i,
    'lead' || i || '@potential.com',
    '555-' || LPAD((floor(random() * 10000))::text, 4, '0') || '-' || LPAD((floor(random() * 10000))::text, 4, '0'),
    (ARRAY['Website', 'Social Media', 'Email Campaign', 'Referral', 'Cold Call', 'Trade Show', 'Advertisement', 'Partner'])[floor(random() * 8) + 1],
    (ARRAY['New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'])[floor(random() * 5) + 1]::LEAD_STATUS_TYPE,
    floor(random() * 100),
    (ARRAY['Sales Rep A', 'Sales Rep B', 'Sales Rep C', 'Sales Rep D', 'Sales Rep E'])[floor(random() * 5) + 1]
FROM generate_series(1, 6000) AS i;

-- Generate Deals (4000 records)
INSERT INTO deals (DEAL_NAME, CUSTOMER_ID, LEAD_ID, STAGE, VALUE, PROBABILITY, EXPECTED_CLOSE_DATE, ASSIGNED_TO)
SELECT
    'Deal ' || i || ' - ' || (ARRAY['Software License', 'Consulting', 'Hardware', 'Support', 'Training'])[floor(random() * 5) + 1],
    CASE WHEN random() > 0.3 THEN (SELECT ID FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() > 0.5 THEN (SELECT ID FROM leads ORDER BY random() LIMIT 1) ELSE NULL END,
    (ARRAY['Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'])[floor(random() * 6) + 1]::DEAL_STAGE_TYPE,
    round((random() * 100000 + 1000)::numeric, 2),
    floor(random() * 100),
    CURRENT_DATE + (floor(random() * 180)) * interval '1 day',
    (ARRAY['Sales Rep A', 'Sales Rep B', 'Sales Rep C', 'Sales Rep D', 'Sales Rep E'])[floor(random() * 5) + 1]
FROM generate_series(1, 4000) AS i;

-- Generate Tasks (10000 records)
INSERT INTO tasks (TITLE, DESCRIPTION, CUSTOMER_ID, LEAD_ID, DEAL_ID, ASSIGNED_TO, STATUS, PRIORITY, DUE_DATE, ESTIMATED_HOURS)
SELECT
    'Task ' || i || ' - ' || (ARRAY['Follow up call', 'Send proposal', 'Meeting preparation', 'Contract review', 'Technical demo', 'Training session'])[floor(random() * 6) + 1],
    'Task description for task ' || i,
    CASE WHEN random() > 0.5 THEN (SELECT ID FROM customers ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() > 0.7 THEN (SELECT ID FROM leads ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() > 0.6 THEN (SELECT ID FROM deals ORDER BY random() LIMIT 1) ELSE NULL END,
    (ARRAY['John Smith', 'Jane Doe', 'Mike Johnson', 'Sarah Wilson', 'David Brown', 'Lisa Davis', 'Tom Anderson', 'Amy Taylor'])[floor(random() * 8) + 1],
    (ARRAY['Not Started', 'In Progress', 'Completed', 'Deferred'])[floor(random() * 4) + 1]::TASK_STATUS_TYPE,
    (ARRAY['Low', 'Medium', 'High', 'Critical'])[floor(random() * 4) + 1]::PRIORITY_TYPE,
    CURRENT_TIMESTAMP + (floor(random() * 60)) * interval '1 day',
    round((random() * 8 + 1)::numeric, 1)
FROM generate_series(1, 10000) AS i;

-- Generate Invoices (8000 records)
INSERT INTO invoices (INVOICE_NUMBER, CUSTOMER_ID, ORDER_ID, DEAL_ID, INVOICE_DATE, DUE_DATE, STATUS, SUBTOTAL, TAX_RATE, TAX_AMOUNT, TOTAL_AMOUNT)
SELECT
    'INV' || LPAD(i::text, 8, '0'),
    (SELECT ID FROM customers ORDER BY random() LIMIT 1),
    CASE WHEN random() > 0.5 THEN (SELECT ID FROM orders ORDER BY random() LIMIT 1) ELSE NULL END,
    CASE WHEN random() > 0.7 THEN (SELECT ID FROM deals ORDER BY random() LIMIT 1) ELSE NULL END,
    CURRENT_DATE - (floor(random() * 90)) * interval '1 day',
    CURRENT_DATE - (floor(random() * 90)) * interval '1 day' + interval '30 days',
    (ARRAY['Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled'])[floor(random() * 5) + 1]::INVOICE_STATUS_TYPE,
    round((random() * 10000 + 100)::numeric, 2),
    20.00,
    round(((random() * 10000 + 100) * 0.2)::numeric, 2),
    round(((random() * 10000 + 100) + (random() * 10000 + 100) * 0.2)::numeric, 2)
FROM generate_series(1, 8000) AS i;

-- Generate Deliveries (7000 records)
INSERT INTO deliveries (DELIVERY_NUMBER, ORDER_ID, CARRIER, TRACKING_NUMBER, STATUS, SHIPPING_DATE, EXPECTED_DELIVERY_DATE, DELIVERY_ADDRESS_ID, RECIPIENT_NAME, RECIPIENT_PHONE)
SELECT
    'DEL' || LPAD(i::text, 8, '0'),
    (SELECT ID FROM orders ORDER BY random() LIMIT 1),
    (ARRAY['DHL', 'FedEx', 'UPS', 'Russian Post', 'CDEK', 'Boxberry'])[floor(random() * 6) + 1],
    'TRK' || LPAD((floor(random() * 1000000))::text, 6, '0'),
    (ARRAY['Preparing', 'Shipped', 'In Transit', 'Delivered', 'Failed'])[floor(random() * 5) + 1]::DELIVERY_STATUS_TYPE,
    CURRENT_TIMESTAMP - (floor(random() * 30)) * interval '1 day',
    CURRENT_TIMESTAMP + (floor(random() * 7)) * interval '1 day',
    (SELECT ID FROM addresses ORDER BY random() LIMIT 1),
    'Recipient ' || i,
    '555-' || LPAD((floor(random() * 10000))::text, 4, '0') || '-' || LPAD((floor(random() * 10000))::text, 4, '0')
FROM generate_series(1, 7000) AS i;

-- Generate Support Tickets (3000 records)
INSERT INTO support_tickets (TICKET_NUMBER, CUSTOMER_ID, SUBJECT, DESCRIPTION, PRIORITY, STATUS, CATEGORY, ASSIGNED_TO)
SELECT
    'TICKET' || LPAD(i::text, 6, '0'),
    (SELECT ID FROM customers ORDER BY random() LIMIT 1),
    (ARRAY['Login Issues', 'Payment Problem', 'Product Defect', 'Shipping Delay', 'Feature Request', 'Technical Support', 'Account Access', 'Billing Question', 'Order Status', 'General Inquiry'])[floor(random() * 10) + 1],
    'Support ticket description for ticket ' || i,
    (ARRAY['Low', 'Medium', 'High', 'Critical'])[floor(random() * 4) + 1]::PRIORITY_TYPE,
    (ARRAY['Open', 'In Progress', 'Resolved', 'Closed', 'Reopened'])[floor(random() * 5) + 1]::TICKET_STATUS_TYPE,
    (ARRAY['Technical', 'Billing', 'Sales', 'General', 'Bug Report', 'Feature Request'])[floor(random() * 6) + 1],
    (ARRAY['Support Agent A', 'Support Agent B', 'Support Agent C', 'Support Agent D', 'Support Agent E', 'Support Agent F'])[floor(random() * 6) + 1]
FROM generate_series(1, 3000) AS i;

-- Generate Customer-Company relationships (5000 records)
INSERT INTO customer_companies (CUSTOMER_ID, COMPANY_ID, ROLE, START_DATE, IS_PRIMARY)
SELECT
    (SELECT ID FROM customers ORDER BY random() LIMIT 1),
    (SELECT ID FROM companies ORDER BY random() LIMIT 1),
    (ARRAY['CEO', 'CTO', 'Manager', 'Employee', 'Consultant', 'Partner'])[floor(random() * 6) + 1],
    CURRENT_DATE - (floor(random() * 1000)) * interval '1 day',
    CASE WHEN i % 4 = 0 THEN true ELSE false END
FROM generate_series(1, 5000) AS i;
