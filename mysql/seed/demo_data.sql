-- Comprehensive English Demo Data for MySQL Customer Database
USE customer_db;

-- Set character set for session
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET collation_connection = utf8mb4_unicode_ci;

-- Insert customer segments first
INSERT INTO customer_segments (segment_name, description, criteria, is_active) VALUES
('VIP Customers', 'High-value customers with premium service requirements', '{"min_order_value": 10000, "purchase_frequency": "monthly"}', TRUE),
('Enterprise Clients', 'Large business customers with corporate accounts', '{"company_size": "large", "employee_count": ">500"}', TRUE),
('New Customers', 'Recently registered customers requiring onboarding', '{"registration_days": "<30"}', TRUE),
('Loyal Customers', 'Long-term customers with consistent engagement', '{"customer_since": ">2_years", "active_orders": ">10"}', TRUE),
('At-Risk Customers', 'Customers showing declining engagement patterns', '{"last_login": ">90_days", "support_tickets": ">3"}', TRUE);

-- Insert companies
INSERT INTO companies (company_name, legal_name, registration_number, tax_number, industry, company_size, website, founded_year, description, annual_revenue, employee_count, logo_url) VALUES
('TechInnovate Solutions', 'TechInnovate Solutions LLC', 'TI-2019-001', 'TAX-TI-789456', 'Technology', 'Large', 'https://techinnovate.com', 2019, 'Leading provider of innovative technology solutions for enterprise clients', 15750000.00, 250, 'https://cdn.example.com/logos/techinnovate.png'),
('Global Marketing Pro', 'Global Marketing Pro Inc.', 'GMP-2018-045', 'TAX-GMP-456789', 'Marketing', 'Medium', 'https://globalmarketingpro.com', 2018, 'Full-service digital marketing agency specializing in B2B campaigns', 5400000.00, 85, 'https://cdn.example.com/logos/globalmarketing.png'),
('BuildCraft Construction', 'BuildCraft Construction Corp', 'BC-2020-078', 'TAX-BC-123789', 'Construction', 'Large', 'https://buildcraft.com', 2020, 'Commercial and residential construction company with sustainable practices', 22000000.00, 180, 'https://cdn.example.com/logos/buildcraft.png'),
('HealthFirst Medical', 'HealthFirst Medical Group', 'HFM-2017-023', 'TAX-HFM-987321', 'Healthcare', 'Medium', 'https://healthfirst.com', 2017, 'Comprehensive healthcare services with modern medical facilities', 8900000.00, 95, 'https://cdn.example.com/logos/healthfirst.png'),
('AutoExpert Services', 'AutoExpert Services Ltd', 'AES-2021-156', 'TAX-AES-654987', 'Automotive', 'Small', 'https://autoexpert.com', 2021, 'Premium automotive service center chain with certified technicians', 3200000.00, 45, 'https://cdn.example.com/logos/autoexpert.png'),
('BeautyElite Salon', 'BeautyElite Salon & Spa LLC', 'BES-2019-089', 'TAX-BES-741852', 'Beauty & Wellness', 'Small', 'https://beautyelite.com', 2019, 'Luxury beauty salon and spa offering premium services', 1850000.00, 25, 'https://cdn.example.com/logos/beautyselite.png'),
('LogiFlow Transportation', 'LogiFlow Transportation Inc', 'LFT-2018-134', 'TAX-LFT-963741', 'Logistics', 'Large', 'https://logiflow.com', 2018, 'International logistics and supply chain management company', 18500000.00, 320, 'https://cdn.example.com/logos/logiflow.png'),
('FreshMarket Chain', 'FreshMarket Chain Corp', 'FMC-2016-067', 'TAX-FMC-852147', 'Retail', 'Enterprise', 'https://freshmarket.com', 2016, 'Regional grocery store chain focused on organic and local products', 45600000.00, 1250, 'https://cdn.example.com/logos/freshmarket.png');

-- Insert customers
INSERT INTO customers (customer_code, first_name, last_name, email, phone, mobile, date_of_birth, gender, registration_date, last_login, status, customer_type, preferred_language, timezone, notes) VALUES
('CUST-001', 'Alexander', 'Thompson', 'alexander.thompson@techinnovate.com', '+1-555-0101', '+1-555-0102', '1975-03-15', 'Male', '2023-01-15 10:30:00', '2024-10-28 14:22:00', 'Active', 'Enterprise', 'en', 'America/New_York', 'CEO of major technology firm, high-value client with enterprise needs'),
('CUST-002', 'Sarah', 'Mitchell', 'sarah.mitchell@globalmarketing.com', '+1-555-0201', '+1-555-0202', '1982-07-22', 'Female', '2023-02-20 15:45:00', '2024-10-29 09:15:00', 'Active', 'Business', 'en', 'America/Los_Angeles', 'Marketing director interested in innovative solutions and latest trends'),
('CUST-003', 'Michael', 'Rodriguez', 'michael.rodriguez@buildcraft.com', '+1-555-0301', '+1-555-0302', '1978-11-08', 'Male', '2023-03-10 11:20:00', '2024-10-27 16:45:00', 'Active', 'Business', 'en', 'America/Chicago', 'Construction project manager specializing in large-scale commercial projects'),
('CUST-004', 'Emily', 'Chen', 'emily.chen@healthfirst.com', '+1-555-0401', '+1-555-0402', '1985-12-18', 'Female', '2023-04-05 08:30:00', '2024-10-30 07:30:00', 'Active', 'VIP', 'en', 'America/New_York', 'Chief Medical Officer of healthcare network, requires premium support'),
('CUST-005', 'David', 'Johnson', 'david.johnson@autoexpert.com', '+1-555-0501', '+1-555-0502', '1980-04-30', 'Male', '2023-05-12 14:15:00', '2024-10-26 18:20:00', 'Active', 'Business', 'en', 'America/Denver', 'Owner of automotive service chain, focus on quality and reliability'),
('CUST-006', 'Jessica', 'Williams', 'jessica.williams@beautyselite.com', '+1-555-0601', '+1-555-0602', '1988-08-14', 'Female', '2023-06-18 12:00:00', '2024-10-29 13:10:00', 'Active', 'Individual', 'en', 'America/Los_Angeles', 'Salon manager interested in premium beauty products and services'),
('CUST-007', 'Robert', 'Davis', 'robert.davis@logiflow.com', '+1-555-0701', '+1-555-0702', '1976-01-25', 'Male', '2023-07-25 16:30:00', '2024-10-28 20:00:00', 'Active', 'Enterprise', 'en', 'America/New_York', 'Logistics operations director managing international supply chains'),
('CUST-008', 'Amanda', 'Wilson', 'amanda.wilson@freshmarket.com', '+1-555-0801', '+1-555-0802', '1983-09-12', 'Female', '2023-08-30 10:45:00', '2024-10-30 11:30:00', 'Active', 'Enterprise', 'en', 'America/Chicago', 'Regional director of grocery chain with focus on organic products'),
('CUST-009', 'Christopher', 'Brown', 'christopher.brown@consultant.com', '+44-20-7946-0901', '+44-7700-900901', '1979-06-03', 'Male', '2023-09-15 13:20:00', '2024-10-25 15:45:00', 'Active', 'VIP', 'en', 'Europe/London', 'Independent business consultant specializing in premium real estate'),
('CUST-010', 'Jennifer', 'Taylor', 'jennifer.taylor@educenter.com', '+1-555-1001', '+1-555-1002', '1986-02-28', 'Female', '2023-10-20 09:10:00', '2024-10-29 12:00:00', 'Active', 'Business', 'en', 'America/New_York', 'Education center director focused on professional development programs'),
('CUST-011', 'Matthew', 'Anderson', 'matthew.anderson@sportlife.com', '+1-555-1101', '+1-555-1102', '1984-10-15', 'Male', '2023-11-10 17:00:00', '2024-10-27 19:30:00', 'Active', 'Individual', 'en', 'America/Los_Angeles', 'Fitness club manager passionate about health and wellness technology'),
('CUST-012', 'Lisa', 'Martin', 'lisa.martin@webcraft.com', '+1-555-1201', '+1-555-1202', '1990-05-20', 'Female', '2023-12-05 11:40:00', '2024-10-30 08:20:00', 'Active', 'Business', 'en', 'America/Pacific', 'Creative director at web design agency, early adopter of new technologies'),
('CUST-013', 'Daniel', 'Garcia', 'daniel.garcia@bizpro.com', '+1-555-1301', '+1-555-1302', '1981-12-07', 'Male', '2024-01-12 14:25:00', '2024-10-28 16:10:00', 'Active', 'Business', 'en', 'America/New_York', 'Senior business consultant with expertise in digital transformation'),
('CUST-014', 'Michelle', 'Lee', 'michelle.lee@gourmet.com', '+1-555-1401', '+1-555-1402', '1987-11-30', 'Female', '2024-02-18 12:15:00', '2024-10-29 14:50:00', 'Active', 'Individual', 'en', 'America/Los_Angeles', 'Executive chef at high-end restaurant, focuses on culinary innovation'),
('CUST-015', 'Kevin', 'White', 'kevin.white@secureguard.com', '+1-555-1501', '+1-555-1502', '1977-08-17', 'Male', '2024-03-22 15:50:00', '2024-10-26 21:15:00', 'Active', 'Business', 'en', 'America/New_York', 'Security services director with focus on corporate protection'),
('CUST-016', 'Rachel', 'Clark', 'rachel.clark@datatech.com', '+1-555-1601', '+1-555-1602', '1989-04-12', 'Female', '2024-04-10 09:30:00', '2024-10-30 16:45:00', 'Active', 'Business', 'en', 'America/Pacific', 'Data analyst specializing in customer behavior and market trends'),
('CUST-017', 'James', 'Hall', 'james.hall@globaltech.com', '+1-555-1701', '+1-555-1702', '1983-07-25', 'Male', '2024-05-15 11:20:00', '2024-10-28 13:30:00', 'Pending', 'Individual', 'en', 'America/New_York', 'Software developer interested in cutting-edge development tools'),
('CUST-018', 'Nicole', 'Young', 'nicole.young@fashionhub.com', '+1-555-1801', '+1-555-1802', '1992-01-08', 'Female', '2024-06-20 14:15:00', '2024-10-29 10:20:00', 'Active', 'Individual', 'en', 'America/Los_Angeles', 'Fashion entrepreneur building online retail presence'),
('CUST-019', 'Brian', 'King', 'brian.king@consultplus.com', '+1-555-1901', '+1-555-1902', '1975-09-14', 'Male', '2024-07-08 16:45:00', '2024-10-27 18:15:00', 'Active', 'VIP', 'en', 'America/Chicago', 'Management consultant with Fortune 500 client portfolio'),
('CUST-020', 'Stephanie', 'Wright', 'stephanie.wright@techstart.com', '+1-555-2001', '+1-555-2002', '1991-03-22', 'Female', '2024-08-12 13:00:00', '2024-10-30 12:45:00', 'Active', 'Individual', 'en', 'America/Pacific', 'Startup founder developing innovative mobile applications');

-- Insert customer-company relationships
INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Chief Executive Officer', 'Executive', TRUE, '2019-01-01'
FROM customers c, companies comp
WHERE c.customer_code = 'CUST-001' AND comp.company_name = 'TechInnovate Solutions';

INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Marketing Director', 'Marketing', TRUE, '2020-03-15'
FROM customers c, companies comp
WHERE c.customer_code = 'CUST-002' AND comp.company_name = 'Global Marketing Pro';

INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Project Manager', 'Construction', TRUE, '2021-06-01'
FROM customers c, companies comp
WHERE c.customer_code = 'CUST-003' AND comp.company_name = 'BuildCraft Construction';

-- Insert addresses
INSERT INTO addresses (customer_id, address_type, street_address, apartment, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '1234 Innovation Drive', 'Suite 500', 'San Francisco', 'California', '94102', 'United States', TRUE
FROM customers WHERE customer_code = 'CUST-001';

INSERT INTO addresses (customer_id, address_type, street_address, apartment, city, state_province, postal_code, country, is_default)
SELECT id, 'Home', '5678 Residential Lane', 'Apt 12A', 'Palo Alto', 'California', '94301', 'United States', FALSE
FROM customers WHERE customer_code = 'CUST-001';

INSERT INTO addresses (customer_id, address_type, street_address, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '2468 Marketing Boulevard', 'Los Angeles', 'California', '90210', 'United States', TRUE
FROM customers WHERE customer_code = 'CUST-002';

INSERT INTO addresses (customer_id, address_type, street_address, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '9876 Construction Avenue', 'Chicago', 'Illinois', '60601', 'United States', TRUE
FROM customers WHERE customer_code = 'CUST-003';

-- Insert communication preferences
INSERT INTO communication_preferences (customer_id, email_marketing, sms_notifications, phone_calls, newsletter, promotional_offers, event_invitations, preferred_contact_method, contact_frequency)
SELECT id, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, 'Email', 'Weekly'
FROM customers WHERE customer_code IN ('CUST-001', 'CUST-002', 'CUST-003');

INSERT INTO communication_preferences (customer_id, email_marketing, sms_notifications, phone_calls, newsletter, promotional_offers, event_invitations, preferred_contact_method, contact_frequency)
SELECT id, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, 'SMS', 'Monthly'
FROM customers WHERE customer_code IN ('CUST-004', 'CUST-005');

-- Insert customer segment assignments
INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'System Auto-Assignment', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('CUST-001', 'CUST-007', 'CUST-008') AND cs.segment_name = 'Enterprise Clients';

INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'Sales Team', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('CUST-004', 'CUST-009', 'CUST-019') AND cs.segment_name = 'VIP Customers';

INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'Marketing Automation', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('CUST-017', 'CUST-018', 'CUST-020') AND cs.segment_name = 'New Customers';

-- Insert sample orders
INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'ORD-2024-001', id, '2024-01-15 14:30:00', 'Delivered', 15750.50, 'USD', 'Credit Card', 'Paid', 'Express Shipping', 'Enterprise software license renewal'
FROM customers WHERE customer_code = 'CUST-001';

INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'ORD-2024-002', id, '2024-02-20 11:45:00', 'Delivered', 8900.00, 'USD', 'Bank Transfer', 'Paid', 'Standard Shipping', 'Marketing campaign management tools'
FROM customers WHERE customer_code = 'CUST-002';

INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'ORD-2024-003', id, '2024-03-10 09:20:00', 'Processing', 22300.75, 'USD', 'Credit Card', 'Pending', 'Freight Shipping', 'Construction equipment and materials'
FROM customers WHERE customer_code = 'CUST-003';

-- Insert customer interactions
INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Phone', 'Product Demo Request', 'Customer requested detailed demonstration of enterprise features for upcoming renewal decision', '2024-10-25 14:30:00', 45, 'Positive', 'John Smith', 'Inbound Call'
FROM customers WHERE customer_code = 'CUST-001';

INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Email', 'Campaign Performance Review', 'Quarterly review of marketing campaign performance and ROI analysis with recommendations for optimization', '2024-10-28 10:15:00', 30, 'Follow-up Required', 'Sarah Johnson', 'Email'
FROM customers WHERE customer_code = 'CUST-002';

INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Meeting', 'Project Planning Session', 'On-site meeting to discuss upcoming construction project requirements and timeline planning', '2024-10-29 13:00:00', 120, 'Positive', 'Mike Davis', 'In-Person'
FROM customers WHERE customer_code = 'CUST-003';

-- Insert support tickets
INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to, resolution)
SELECT 'TKT-2024-001', id, 'Login Issues with Enterprise Portal', 'Customer reports intermittent login failures when accessing the enterprise dashboard during peak hours', 'High', 'Resolved', 'Technical Support', 'Tech Support Team', 'Identified and resolved server capacity issue. Implemented load balancing improvements.'
FROM customers WHERE customer_code = 'CUST-001';

INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to)
SELECT 'TKT-2024-002', id, 'Feature Request: Advanced Analytics', 'Request to add advanced analytics dashboard with custom reporting capabilities for campaign performance tracking', 'Medium', 'In Progress', 'Feature Request', 'Product Development Team'
FROM customers WHERE customer_code = 'CUST-002';

INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to)
SELECT 'TKT-2024-003', id, 'Billing Inquiry: Volume Discount', 'Question about eligibility for volume discounts on large equipment orders and bulk purchasing programs', 'Low', 'Open', 'Billing Support', 'Billing Team'
FROM customers WHERE customer_code = 'CUST-003';
