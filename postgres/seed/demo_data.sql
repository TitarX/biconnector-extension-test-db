-- Demo seed data aligned with current PostgreSQL schema
-- Table names: lowercase, Field names: UPPERCASE (quoted)

SET client_encoding = 'UTF8';
SET timezone = 'UTC';

-- Customers (5000)
INSERT INTO customers ("CUSTOMER_CODE","FIRST_NAME","LAST_NAME","EMAIL","PHONE","MOBILE","DATE_OF_BIRTH","GENDER","STATUS","CUSTOMER_TYPE","PREFERRED_LANGUAGE","TIMEZONE","AVATAR_URL","NOTES")
SELECT
  'CUST' || LPAD(gs::text,6,'0'),
  'FirstName' || gs,
  'LastName' || gs,
  'customer' || gs || '@example.com',
  '+7495' || LPAD((random()*10000000)::int::text,7,'0'),
  '+7985' || LPAD((random()*10000000)::int::text,7,'0'),
  (CURRENT_DATE - (18 + floor(random()*50)) * INTERVAL '1 year')::date,
  (ARRAY['Male','Female','Other','Prefer not to say'])[1 + floor(random()*4)::int],
  (ARRAY['Active','Inactive','Suspended','Pending'])[1 + floor(random()*4)::int],
  (ARRAY['Individual','Business','Enterprise','VIP'])[1 + floor(random()*4)::int],
  (ARRAY['en','ru','de'])[1 + floor(random()*3)::int],
  (ARRAY['UTC','Europe/Moscow','Europe/Berlin'])[1 + floor(random()*3)::int],
  'https://avatar.example.com/cust' || gs || '.jpg',
  'Notes for customer ' || gs
FROM generate_series(1,5000) AS gs;

-- Companies (1000)
INSERT INTO companies ("COMPANY_NAME","LEGAL_NAME","REGISTRATION_NUMBER","TAX_NUMBER","INDUSTRY","COMPANY_SIZE","WEBSITE","FOUNDED_YEAR","DESCRIPTION","ANNUAL_REVENUE","EMPLOYEE_COUNT","LOGO_URL")
SELECT
  'Company ' || gs || ' LLC',
  'Legal Name ' || gs,
  'REG' || LPAD(gs::text,8,'0'),
  'TAX' || LPAD(gs::text,10,'0'),
  (ARRAY['Technology','Finance','Healthcare','Retail','Manufacturing','Education','Energy','Media','Agriculture','Logistics'])[1 + floor(random()*10)::int],
  (ARRAY['Startup','Small','Medium','Large','Enterprise'])[1 + floor(random()*5)::int],
  'https://company' || gs || '.com',
  1990 + floor(random()*33)::int,
  'Description for company ' || gs,
  round((random()*50000000 + 10000)::numeric,2),
  (random()*10000)::int + 1,
  'https://logo.example.com/company' || gs || '.png'
FROM generate_series(1,1000) AS gs;

-- Customer-Company relations (2500)
INSERT INTO customer_companies ("CUSTOMER_ID","COMPANY_ID","ROLE","START_DATE","END_DATE","IS_PRIMARY")
SELECT
  (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
  (SELECT "ID" FROM companies ORDER BY random() LIMIT 1),
  (ARRAY['Employee','Manager','Director','Consultant','Partner'])[1 + floor(random()*5)::int],
  CURRENT_DATE - (floor(random()*1460)) * INTERVAL '1 day',
  CASE WHEN random() < 0.2 THEN CURRENT_DATE + (floor(random()*730)) * INTERVAL '1 day' END,
  random() < 0.3
FROM generate_series(1,2500);

-- Addresses (8000)
INSERT INTO addresses ("CUSTOMER_ID","COMPANY_ID","ADDRESS_TYPE","STREET_ADDRESS","APARTMENT","CITY","STATE_PROVINCE","POSTAL_CODE","COUNTRY","LATITUDE","LONGITUDE","IS_DEFAULT")
SELECT
  CASE WHEN random()<0.8 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) END,
  CASE WHEN random()<0.3 THEN (SELECT "ID" FROM companies ORDER BY random() LIMIT 1) END,
  (ARRAY['Home','Work','Billing','Shipping','Other'])[1 + floor(random()*5)::int],
  'Street ' || gs || ', Building ' || (floor(random()*200)+1),
  CASE WHEN random()<0.5 THEN (floor(random()*300)+1)::text END,
  (ARRAY['Moscow','Saint Petersburg','Novosibirsk','Yekaterinburg','Kazan','Samara','Rostov-on-Don','Ufa','Perm','Volgograd'])[1 + floor(random()*10)::int],
  (ARRAY['Moscow Oblast','Leningrad Oblast','Novosibirsk Oblast','Sverdlovsk Oblast','Tatarstan'])[1 + floor(random()*5)::int],
  LPAD((floor(random()*999999))::text,6,'0'),
  'Russia',
  55.75 + (random()-0.5) * 5,
  37.61 + (random()-0.5) * 5,
  random() < 0.15
FROM generate_series(1,8000) AS gs;

-- Products (2000)
INSERT INTO products ("PRODUCT_CODE","NAME","DESCRIPTION","CATEGORY","SUBCATEGORY","BRAND","PRICE","COST","WEIGHT","DIMENSIONS","COLOR","SIZE","MATERIAL","STOCK_QUANTITY","MIN_STOCK_LEVEL","IS_ACTIVE","IMAGE_URL")
SELECT
  'PROD' || LPAD(gs::text,6,'0'),
  'Product ' || gs,
  'Description for product ' || gs,
  (ARRAY['Electronics','Computers','Audio','Gaming','Office','Furniture','Accessories','Mobile'])[1 + floor(random()*8)::int],
  (ARRAY['Premium','Standard','Budget','Professional','Consumer'])[1 + floor(random()*5)::int],
  (ARRAY['Apple','Samsung','Sony','LG','HP','Dell','Lenovo','Asus','Logitech','Microsoft'])[1 + floor(random()*10)::int],
  round((random()*100000 + 100)::numeric,2),
  round((random()*80000 + 50)::numeric,2),
  round((random()*5 + 0.1)::numeric,3),
  (10 + floor(random()*90)) || 'x' || (10 + floor(random()*90)) || 'x' || (1 + floor(random()*30)) || ' cm',
  (ARRAY['Black','White','Silver','Gray','Blue','Red','Green','Gold'])[1 + floor(random()*8)::int],
  (ARRAY['Small','Medium','Large','XL','Universal'])[1 + floor(random()*5)::int],
  (ARRAY['Plastic','Metal','Glass','Composite','Carbon Fiber'])[1 + floor(random()*5)::int],
  (random()*2000)::int,
  (random()*100)::int + 5,
  random() < 0.95,
  'https://images.example.com/prod' || gs || '.jpg'
FROM generate_series(1,2000) AS gs;

-- Orders (10000)
INSERT INTO orders ("ORDER_NUMBER","CUSTOMER_ID","ORDER_DATE","STATUS","PAYMENT_METHOD","PAYMENT_STATUS","SUBTOTAL","TAX_AMOUNT","SHIPPING_AMOUNT","DISCOUNT_AMOUNT","TOTAL_AMOUNT","CURRENCY","SHIPPING_ADDRESS_ID","BILLING_ADDRESS_ID","NOTES")
SELECT
  'ORD' || LPAD(gs::text,8,'0'),
  (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
  CURRENT_TIMESTAMP - (floor(random()*365)) * INTERVAL '1 day',
  (ARRAY['Pending','Processing','Shipped','Delivered','Cancelled','Refunded'])[1 + floor(random()*6)::int],
  (ARRAY['Credit Card','Debit Card','PayPal','Bank Transfer','Cash','Crypto'])[1 + floor(random()*6)::int],
  (ARRAY['Pending','Paid','Failed','Refunded','Partially Refunded'])[1 + floor(random()*5)::int],
  round((random()*5000+50)::numeric,2),
  round((random()*1000)::numeric,2),
  round((random()*400)::numeric,2),
  round((random()*300)::numeric,2),
  round((random()*6500+100)::numeric,2),
  'RUB',
  (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
  (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
  'Seed order ' || gs
FROM generate_series(1,10000) AS gs;

-- Order Items (25000)
INSERT INTO order_items ("ORDER_ID","PRODUCT_ID","QUANTITY","UNIT_PRICE","TOTAL_PRICE","DISCOUNT_AMOUNT")
SELECT
  (SELECT "ID" FROM orders ORDER BY random() LIMIT 1),
  (SELECT "ID" FROM products ORDER BY random() LIMIT 1),
  (floor(random()*5)+1),
  round((random()*100000 + 100)::numeric,2),
  round((random()*5+1) * (random()*100000 + 100)::numeric,2),
  round((random()*500)::numeric,2)
FROM generate_series(1,25000);

-- Leads (3000)
INSERT INTO leads ("LEAD_CODE","FIRST_NAME","LAST_NAME","COMPANY_NAME","EMAIL","PHONE","SOURCE","STATUS","SCORE","ASSIGNED_TO","NOTES","CONVERSION_DATE","CONVERTED_CUSTOMER_ID")
SELECT
  'LEAD' || LPAD(gs::text,6,'0'),
  (ARRAY['Ivan','Maria','Alexander','Elena','Dmitry','Anna','Sergey','Olga'])[1 + floor(random()*8)::int],
  (ARRAY['Petrov','Ivanov','Sidorov','Kozlov','Novikov','Morozov','Popov','Volkov'])[1 + floor(random()*8)::int],
  'Lead Company ' || gs,
  'lead' || gs || '@example.com',
  '+7495' || LPAD((random()*10000000)::int::text,7,'0'),
  (ARRAY['Website','Social Media','Email Campaign','Referral','Trade Show','Cold Call','Advertisement','Partner'])[1 + floor(random()*8)::int],
  (ARRAY['New','Contacted','Qualified','Disqualified','Converted'])[1 + floor(random()*5)::int],
  (random()*100)::int,
  (ARRAY['Sales Rep 1','Sales Rep 2','Sales Rep 3','Sales Rep 4','Sales Manager'])[1 + floor(random()*5)::int],
  'Lead notes ' || gs,
  CASE WHEN random()<0.15 THEN CURRENT_TIMESTAMP - (floor(random()*90))*INTERVAL '1 day' END,
  CASE WHEN random()<0.15 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) END
FROM generate_series(1,3000) AS gs;

-- Deals (2000)
INSERT INTO deals ("DEAL_NAME","CUSTOMER_ID","LEAD_ID","STAGE","VALUE","CURRENCY","PROBABILITY","EXPECTED_CLOSE_DATE","ACTUAL_CLOSE_DATE","ASSIGNED_TO","NOTES")
SELECT
  'Deal ' || gs || ' - ' || (ARRAY['Software License','Consulting','Hardware','Support','Training','Integration','Maintenance','Custom Solution'])[1 + floor(random()*8)::int],
  CASE WHEN random()<0.7 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) END,
  CASE WHEN random()<0.4 THEN (SELECT "ID" FROM leads ORDER BY random() LIMIT 1) END,
  (ARRAY['Prospecting','Qualification','Proposal','Negotiation','Closed Won','Closed Lost'])[1 + floor(random()*6)::int],
  round((random()*1000000 + 5000)::numeric,2),
  'RUB',
  (random()*100)::int,
  CURRENT_DATE + (floor(random()*150)) * INTERVAL '1 day',
  CASE WHEN random()<0.25 THEN CURRENT_DATE - (floor(random()*60)) * INTERVAL '1 day' END,
  (ARRAY['Sales Rep 1','Sales Rep 2','Sales Rep 3','Sales Rep 4','Sales Manager'])[1 + floor(random()*5)::int],
  'Deal notes ' || gs
FROM generate_series(1,2000) AS gs;

-- Tasks (5000)
INSERT INTO tasks ("TITLE","DESCRIPTION","CUSTOMER_ID","LEAD_ID","DEAL_ID","ASSIGNED_TO","STATUS","PRIORITY","DUE_DATE","COMPLETED_DATE","ESTIMATED_HOURS","ACTUAL_HOURS")
SELECT
  'Task ' || gs || ' - ' || (ARRAY['Follow up','Meeting','Proposal','Review','Analysis','Demo','Negotiation','Preparation','Presentation','Planning'])[1 + floor(random()*10)::int],
  'Task description ' || gs,
  CASE WHEN random()<0.6 THEN (SELECT "ID" FROM customers ORDER BY random() LIMIT 1) END,
  CASE WHEN random()<0.3 THEN (SELECT "ID" FROM leads ORDER BY random() LIMIT 1) END,
  CASE WHEN random()<0.4 THEN (SELECT "ID" FROM deals ORDER BY random() LIMIT 1) END,
  (ARRAY['Sales Rep 1','Sales Rep 2','Sales Rep 3','Sales Manager','Account Manager','Technical Lead','Project Manager','Support Specialist'])[1 + floor(random()*8)::int],
  (ARRAY['Not Started','In Progress','Completed','Deferred'])[1 + floor(random()*4)::int],
  (ARRAY['Low','Medium','High','Critical'])[1 + floor(random()*4)::int],
  CURRENT_TIMESTAMP + (floor(random()*120)) * INTERVAL '1 day',
  CASE WHEN random()<0.35 THEN CURRENT_TIMESTAMP - (floor(random()*60))*INTERVAL '1 day' END,
  round((random()*40+1)::numeric,2),
  CASE WHEN random()<0.3 THEN round((random()*40+0.5)::numeric,2) END
FROM generate_series(1,5000) AS gs;

-- Invoices (7000)
INSERT INTO invoices ("INVOICE_NUMBER","CUSTOMER_ID","ORDER_ID","DEAL_ID","INVOICE_DATE","DUE_DATE","STATUS","SUBTOTAL","TAX_RATE","TAX_AMOUNT","DISCOUNT_AMOUNT","TOTAL_AMOUNT","CURRENCY","NOTES","PAYMENT_DATE")
SELECT
  'INV' || LPAD(gs::text,7,'0') || '/' || EXTRACT(YEAR FROM CURRENT_DATE),
  (SELECT "ID" FROM customers ORDER BY random() LIMIT 1),
  CASE WHEN random()<0.75 THEN (SELECT "ID" FROM orders ORDER BY random() LIMIT 1) END,
  CASE WHEN random()<0.35 THEN (SELECT "ID" FROM deals ORDER BY random() LIMIT 1) END,
  CURRENT_DATE - (floor(random()*120)) * INTERVAL '1 day',
  CURRENT_DATE - (floor(random()*120)) * INTERVAL '1 day' + INTERVAL '30 day',
  (ARRAY['Draft','Sent','Paid','Overdue','Cancelled'])[1 + floor(random()*5)::int],
  round((random()*20000+500)::numeric,2),
  20.0,
  round((random()*4000+100)::numeric,2),
  round((random()*2000)::numeric,2),
  round((random()*25000+600)::numeric,2),
  'RUB',
  'Seed invoice ' || gs,
  CASE WHEN random()<0.55 THEN CURRENT_DATE - (floor(random()*90))*INTERVAL '1 day' END
FROM generate_series(1,7000) AS gs;

-- Deliveries (6000)
INSERT INTO deliveries ("DELIVERY_NUMBER","ORDER_ID","CARRIER","TRACKING_NUMBER","STATUS","SHIPPING_DATE","EXPECTED_DELIVERY_DATE","ACTUAL_DELIVERY_DATE","DELIVERY_ADDRESS_ID","RECIPIENT_NAME","RECIPIENT_PHONE","NOTES")
SELECT
  'DEL' || LPAD(gs::text,8,'0'),
  (SELECT "ID" FROM orders ORDER BY random() LIMIT 1),
  (ARRAY['Russian Post','CDEK','Boxberry','Pochta Express','DHL','FedEx'])[1 + floor(random()*6)::int],
  'TRK' || LPAD((floor(random()*999999999))::text,12,'0'),
  (ARRAY['Preparing','Shipped','In Transit','Delivered','Failed'])[1 + floor(random()*5)::int],
  CURRENT_TIMESTAMP - (floor(random()*60))*INTERVAL '1 day',
  CURRENT_TIMESTAMP - (floor(random()*60))*INTERVAL '1 day' + (floor(random()*10)+1)*INTERVAL '1 day',
  CASE WHEN random()<0.7 THEN CURRENT_TIMESTAMP - (floor(random()*60))*INTERVAL '1 day' + (floor(random()*12)+1)*INTERVAL '1 day' END,
  (SELECT "ID" FROM addresses ORDER BY random() LIMIT 1),
  (ARRAY['Ivan Petrov','Maria Ivanova','Alexander Sidorov','Elena Kozlova','Dmitry Novikov','Anna Morozova','Sergey Popov','Olga Volkova'])[1 + floor(random()*8)::int],
  '+7495' || LPAD((random()*10000000)::int::text,7,'0'),
  'Delivery notes ' || gs
FROM generate_series(1,6000) AS gs;

-- Fallback block to ensure orders & invoices populated
DO $$
DECLARE ord_cnt INT; inv_cnt INT; cust_cnt INT; addr_cnt INT; deal_cnt INT; BEGIN
  SELECT COUNT(*) INTO ord_cnt FROM orders; SELECT COUNT(*) INTO inv_cnt FROM invoices;
  IF ord_cnt = 0 THEN
    SELECT COUNT(*) INTO cust_cnt FROM customers; SELECT COUNT(*) INTO addr_cnt FROM addresses;
    INSERT INTO orders ("ORDER_NUMBER","CUSTOMER_ID","ORDER_DATE","STATUS","PAYMENT_METHOD","PAYMENT_STATUS","SUBTOTAL","TAX_AMOUNT","SHIPPING_AMOUNT","DISCOUNT_AMOUNT","TOTAL_AMOUNT","CURRENCY","SHIPPING_ADDRESS_ID","BILLING_ADDRESS_ID","NOTES")
    SELECT
      'ORDFB' || LPAD(gs::text,8,'0'),
      (SELECT "ID" FROM customers OFFSET floor(random()*cust_cnt) LIMIT 1),
      CURRENT_TIMESTAMP - (floor(random()*200))*INTERVAL '1 day',
      (ARRAY['Pending','Processing','Shipped','Delivered','Cancelled','Refunded'])[1 + floor(random()*6)::int],
      (ARRAY['Credit Card','Debit Card','PayPal','Bank Transfer','Cash','Crypto'])[1 + floor(random()*6)::int],
      (ARRAY['Pending','Paid','Failed','Refunded','Partially Refunded'])[1 + floor(random()*5)::int],
      round((random()*3000+50)::numeric,2),
      round((random()*600)::numeric,2),
      round((random()*250)::numeric,2),
      round((random()*150)::numeric,2),
      round((random()*4000+100)::numeric,2),
      'RUB',
      CASE WHEN addr_cnt>0 THEN (SELECT "ID" FROM addresses OFFSET floor(random()*addr_cnt) LIMIT 1) END,
      CASE WHEN addr_cnt>0 THEN (SELECT "ID" FROM addresses OFFSET floor(random()*addr_cnt) LIMIT 1) END,
      'Fallback seed order ' || gs
    FROM generate_series(1,1500) AS gs;
  END IF;
  SELECT COUNT(*) INTO inv_cnt FROM invoices; -- refresh
  IF inv_cnt = 0 THEN
    SELECT COUNT(*) INTO deal_cnt FROM deals; SELECT COUNT(*) INTO ord_cnt FROM orders; SELECT COUNT(*) INTO cust_cnt FROM customers;
    INSERT INTO invoices ("INVOICE_NUMBER","CUSTOMER_ID","ORDER_ID","DEAL_ID","INVOICE_DATE","DUE_DATE","STATUS","SUBTOTAL","TAX_RATE","TAX_AMOUNT","DISCOUNT_AMOUNT","TOTAL_AMOUNT","CURRENCY","NOTES")
    SELECT
      'INVFB' || gs || '/' || EXTRACT(YEAR FROM CURRENT_DATE),
      (SELECT "ID" FROM customers OFFSET floor(random()*cust_cnt) LIMIT 1),
      CASE WHEN ord_cnt>0 AND random()<0.7 THEN (SELECT "ID" FROM orders OFFSET floor(random()*ord_cnt) LIMIT 1) END,
      CASE WHEN deal_cnt>0 AND random()<0.3 THEN (SELECT "ID" FROM deals OFFSET floor(random()*deal_cnt) LIMIT 1) END,
      CURRENT_DATE - (floor(random()*120))*INTERVAL '1 day',
      (CURRENT_DATE - (floor(random()*120))*INTERVAL '1 day') + INTERVAL '30 day',
      (ARRAY['Draft','Sent','Paid','Overdue','Cancelled'])[1 + floor(random()*5)::int],
      round((random()*10000+200)::numeric,2),
      20.0,
      round((random()*2000+50)::numeric,2),
      round((random()*1000)::numeric,2),
      round((random()*12000+300)::numeric,2),
      'RUB',
      'Fallback seed invoice ' || gs
    FROM generate_series(1,2000) AS gs;
  END IF;
END$$;
