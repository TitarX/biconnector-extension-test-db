-- Generate Data for PostgreSQL

-- Generate Customers
INSERT INTO CUSTOMERS (CUSTOMER_CODE, FIRST_NAME, LAST_NAME, EMAIL, PHONE, MOBILE, DATE_OF_BIRTH, GENDER, STATUS, CUSTOMER_TYPE)
SELECT
    'CUST' || LPAD(i::text, 5, '0'),
    'FirstName' || i,
    'LastName' || i,
    'customer' || i || '@example.com',
    '123-456-' || LPAD(i::text, 4, '0'),
    '987-654-' || LPAD(i::text, 4, '0'),
    CURRENT_DATE - (18 + floor(random() * 50)) * interval '1 year',
    (ARRAY['Male', 'Female', 'Other', 'Prefer not to say'])[floor(random() * 4) + 1]::GENDER_TYPE,
    (ARRAY['Active', 'Inactive', 'Suspended', 'Pending'])[floor(random() * 4) + 1]::CUSTOMER_STATUS_TYPE,
    (ARRAY['Individual', 'Business', 'Enterprise', 'VIP'])[floor(random() * 4) + 1]::CUSTOMER_TYPE_ENUM
FROM generate_series(1, 5000) AS i;

-- Generate Companies
INSERT INTO COMPANIES (COMPANY_NAME, INDUSTRY, COMPANY_SIZE, ANNUAL_REVENUE, EMPLOYEE_COUNT)
SELECT
    'Company' || i,
    (ARRAY['Technology', 'Finance', 'Healthcare', 'Retail', 'Manufacturing'])[floor(random() * 5) + 1],
    (ARRAY['Startup', 'Small', 'Medium', 'Large', 'Enterprise'])[floor(random() * 5) + 1]::COMPANY_SIZE_TYPE,
    random() * 10000000,
    floor(random() * 5000)
FROM generate_series(1, 1000) AS i;

-- Generate Addresses
INSERT INTO ADDRESSES (CUSTOMER_ID, ADDRESS_TYPE, STREET_ADDRESS, CITY, STATE_PROVINCE, POSTAL_CODE, COUNTRY, IS_DEFAULT)
SELECT
    (SELECT ID FROM CUSTOMERS ORDER BY random() LIMIT 1),
    (ARRAY['Home', 'Work', 'Billing', 'Shipping', 'Other'])[floor(random() * 5) + 1]::ADDRESS_TYPE,
    'Street ' || i || ', Building ' || floor(random() * 100),
    'City' || floor(random() * 50),
    'State' || floor(random() * 20),
    LPAD(floor(random() * 99999)::text, 5, '0'),
    'Country' || floor(random() * 10),
    random() < 0.3
FROM generate_series(1, 8000) AS i;

-- Generate Communication Preferences
INSERT INTO COMMUNICATION_PREFERENCES (CUSTOMER_ID, EMAIL_MARKETING, SMS_MARKETING, PHONE_CALLS, PREFERRED_CONTACT_METHOD, CONTACT_FREQUENCY)
SELECT
    (SELECT ID FROM CUSTOMERS ORDER BY random() LIMIT 1),
    random() < 0.7,
    random() < 0.3,
    random() < 0.2,
    (ARRAY['Email', 'Phone', 'SMS', 'Mail'])[floor(random() * 4) + 1]::CONTACT_METHOD_TYPE,
    (ARRAY['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Never'])[floor(random() * 5) + 1]::CONTACT_FREQUENCY_TYPE
FROM generate_series(1, 5000) AS i;

-- Generate Products
INSERT INTO PRODUCTS (PRODUCT_NAME, PRICE, SKU, STOCK_QUANTITY)
SELECT
    'Product ' || i,
    round((random() * 1000)::numeric, 2),
    'SKU' || LPAD(i::text, 6, '0'),
    floor(random() * 1000)
FROM generate_series(1, 2000) AS i;

-- Generate Orders
INSERT INTO ORDERS (CUSTOMER_ID, STATUS, TOTAL_AMOUNT)
SELECT
    (SELECT ID FROM CUSTOMERS ORDER BY random() LIMIT 1),
    (ARRAY['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'])[floor(random() * 5) + 1]::ORDER_STATUS_TYPE,
    round((random() * 5000)::numeric, 2)
FROM generate_series(1, 10000) AS i;

-- Generate Order Items
INSERT INTO ORDER_ITEMS (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
SELECT
    (SELECT ID FROM ORDERS ORDER BY random() LIMIT 1),
    (SELECT ID FROM PRODUCTS ORDER BY random() LIMIT 1),
    floor(random() * 10) + 1,
    (SELECT PRICE FROM PRODUCTS ORDER BY random() LIMIT 1)
FROM generate_series(1, 25000) AS i;


-- Generate Leads
INSERT INTO LEADS (FIRST_NAME, LAST_NAME, EMAIL, PHONE, COMPANY_NAME, STATUS, SOURCE)
SELECT
    'LeadFirst' || i,
    'LeadLast' || i,
    'lead' || i || '@example.com',
    '555-123-' || LPAD(i::text, 4, '0'),
    'Lead Company ' || i,
    (ARRAY['New', 'Contacted', 'Qualified', 'Disqualified', 'Converted'])[floor(random() * 5) + 1]::LEAD_STATUS_TYPE,
    (ARRAY['Web', 'Referral', 'Partner', 'Advertisement'])[floor(random() * 4) + 1]
FROM generate_series(1, 5000) AS i;

-- Generate Tasks
INSERT INTO TASKS (TITLE, DUE_DATE, PRIORITY, STATUS)
SELECT
    'Task ' || i,
    CURRENT_DATE + (floor(random() * 90) * interval '1 day'),
    (ARRAY['Low', 'Medium', 'High', 'Critical'])[floor(random() * 4) + 1]::PRIORITY_TYPE,
    (ARRAY['Not Started', 'In Progress', 'Completed', 'Deferred'])[floor(random() * 4) + 1]::TASK_STATUS_TYPE
FROM generate_series(1, 10000) AS i;

-- Generate Deals
INSERT INTO DEALS (DEAL_NAME, AMOUNT, STAGE, CLOSE_DATE)
SELECT
    'Deal ' || i,
    round((random() * 100000)::numeric, 2),
    (ARRAY['Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost'])[floor(random() * 6) + 1]::DEAL_STAGE_TYPE,
    CURRENT_DATE + (floor(random() * 180) * interval '1 day')
FROM generate_series(1, 3000) AS i;

-- Generate Invoices
INSERT INTO INVOICES (ORDER_ID, INVOICE_DATE, DUE_DATE, TOTAL_AMOUNT, STATUS)
SELECT
    (SELECT ID FROM ORDERS ORDER BY random() LIMIT 1),
    CURRENT_DATE,
    CURRENT_DATE + interval '30 day',
    (SELECT TOTAL_AMOUNT FROM ORDERS ORDER BY random() LIMIT 1),
    (ARRAY['Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled'])[floor(random() * 5) + 1]::INVOICE_STATUS_TYPE
FROM generate_series(1, 9000) AS i;

-- Generate Deliveries
INSERT INTO DELIVERIES (ORDER_ID, SHIPPING_DATE, DELIVERY_DATE, CARRIER, TRACKING_NUMBER, STATUS)
SELECT
    (SELECT ID FROM ORDERS ORDER BY random() LIMIT 1),
    CURRENT_DATE,
    CURRENT_DATE + interval '7 day',
    (ARRAY['UPS', 'FedEx', 'DHL'])[floor(random() * 3) + 1],
    'TRK' || LPAD(floor(random() * 1000000000)::text, 9, '0'),
    (ARRAY['Preparing', 'Shipped', 'In Transit', 'Delivered', 'Failed'])[floor(random() * 5) + 1]::DELIVERY_STATUS_TYPE
FROM generate_series(1, 8000) AS i;

