-- Comprehensive English Demo Data for PostgreSQL Customer Database

-- Set encoding
SET client_encoding = 'UTF8';

-- Insert customer segments first
INSERT INTO customer_segments (segment_name, description, criteria, is_active) VALUES
('Premium Subscribers', 'High-value customers with premium subscription plans', '{"subscription_type": "premium", "monthly_spend": ">1000"}', TRUE),
('Enterprise Accounts', 'Large business customers with enterprise-level requirements', '{"company_size": "enterprise", "contract_value": ">50000"}', TRUE),
('Active Users', 'Customers with high engagement and regular platform usage', '{"login_frequency": "daily", "feature_usage": "advanced"}', TRUE),
('International Clients', 'Customers from international markets requiring localization', '{"country": "non-US", "language_preference": "non-en"}', TRUE),
('Tech Innovators', 'Technology-focused customers adopting cutting-edge solutions', '{"industry": "technology", "early_adopter": true}', TRUE);

-- Insert companies
INSERT INTO companies (company_name, legal_name, registration_number, tax_number, industry, company_size, website, founded_year, description, annual_revenue, employee_count, logo_url) VALUES
('InnovaTech Global', 'InnovaTech Global Corporation', 'ITG-2020-001', 'US-TAX-ITG-789456', 'Technology', 'Enterprise', 'https://innovatech-global.com', 2020, 'Global technology solutions provider specializing in AI and machine learning platforms', 125000000.00, 2500, 'https://cdn.example.com/logos/innovatech.png'),
('Digital Solutions Pro', 'Digital Solutions Pro Ltd', 'DSP-2019-045', 'UK-TAX-DSP-456789', 'Digital Services', 'Large', 'https://digitalsolutions-pro.com', 2019, 'Comprehensive digital transformation services for enterprise clients worldwide', 45000000.00, 850, 'https://cdn.example.com/logos/digitalsolutions.png'),
('CloudFirst Technologies', 'CloudFirst Technologies Inc', 'CFT-2021-078', 'CA-TAX-CFT-123789', 'Cloud Computing', 'Medium', 'https://cloudfirst.tech', 2021, 'Cloud-native infrastructure and platform services for modern businesses', 18000000.00, 180, 'https://cdn.example.com/logos/cloudfirst.png'),
('DataSync Analytics', 'DataSync Analytics Corp', 'DSA-2018-023', 'AU-TAX-DSA-987321', 'Data Analytics', 'Medium', 'https://datasync-analytics.com', 2018, 'Advanced data analytics and business intelligence solutions for data-driven organizations', 22000000.00, 295, 'https://cdn.example.com/logos/datasync.png'),
('MobileFirst Development', 'MobileFirst Development LLC', 'MFD-2022-156', 'US-TAX-MFD-654987', 'Mobile Technology', 'Small', 'https://mobilefirst-dev.com', 2022, 'Cutting-edge mobile application development and consulting services', 5200000.00, 65, 'https://cdn.example.com/logos/mobilefirst.png'),
('SecureNet Solutions', 'SecureNet Solutions International', 'SNS-2017-089', 'DE-TAX-SNS-741852', 'Cybersecurity', 'Large', 'https://securenet-solutions.com', 2017, 'Enterprise cybersecurity solutions and managed security services', 38500000.00, 425, 'https://cdn.example.com/logos/securenet.png'),
('GlobalConnect Consulting', 'GlobalConnect Consulting Group', 'GCC-2016-134', 'SG-TAX-GCC-963741', 'Business Consulting', 'Medium', 'https://globalconnect-consulting.com', 2016, 'International business consulting with expertise in digital transformation', 15800000.00, 220, 'https://cdn.example.com/logos/globalconnect.png'),
('NextGen Platforms', 'NextGen Platforms Corporation', 'NGP-2023-067', 'US-TAX-NGP-852147', 'Software Platforms', 'Startup', 'https://nextgen-platforms.com', 2023, 'Innovative software platforms for next-generation business applications', 2500000.00, 45, 'https://cdn.example.com/logos/nextgen.png');

-- Insert customers
INSERT INTO customers (customer_code, first_name, last_name, email, phone, mobile, date_of_birth, gender, registration_date, last_login, status, customer_type, preferred_language, timezone, notes) VALUES
('USR-001', 'Jonathan', 'Alexander', 'jonathan.alexander@innovatech-global.com', '+1-415-555-0101', '+1-415-555-0102', '1985-05-15', 'Male', '2023-01-20 09:15:00', '2024-10-29 16:45:00', 'Active', 'Enterprise', 'en', 'America/Los_Angeles', 'Senior software architect with expertise in AI/ML platforms and enterprise integration'),
('USR-002', 'Emma', 'Richardson', 'emma.richardson@digitalsolutions-pro.com', '+44-20-7946-0201', '+44-7700-900201', '1988-11-22', 'Female', '2023-02-14 14:30:00', '2024-10-30 10:20:00', 'Active', 'VIP', 'en', 'Europe/London', 'Digital transformation specialist focusing on UX/UI design and user experience optimization'),
('USR-003', 'Marcus', 'Rodriguez', 'marcus.rodriguez@cloudfirst.tech', '+1-647-555-0301', '+1-647-555-0302', '1982-08-03', 'Male', '2023-03-08 11:45:00', '2024-10-28 13:10:00', 'Active', 'Business', 'en', 'America/Toronto', 'Cloud infrastructure expert specializing in scalable distributed systems and DevOps'),
('USR-004', 'Sophia', 'Thompson', 'sophia.thompson@datasync-analytics.com', '+61-2-9555-0401', '+61-400-555-401', '1986-03-18', 'Female', '2023-04-12 08:20:00', '2024-10-29 17:30:00', 'Active', 'Enterprise', 'en', 'Australia/Sydney', 'Senior data scientist with advanced analytics and machine learning expertise'),
('USR-005', 'Chen', 'Wei', 'chen.wei@mobilefirst-dev.com', '+65-6123-4567', '+65-9123-4567', '1990-12-10', 'Male', '2023-05-25 16:00:00', '2024-10-27 12:45:00', 'Active', 'Business', 'en', 'Asia/Singapore', 'Mobile development team lead specializing in cross-platform applications and native iOS/Android'),
('USR-006', 'Isabella', 'Johnson', 'isabella.johnson@securenet-solutions.com', '+49-30-555-0601', '+49-172-555-601', '1984-07-25', 'Female', '2023-06-30 12:30:00', '2024-10-30 09:15:00', 'Active', 'VIP', 'en', 'Europe/Berlin', 'Cybersecurity consultant with expertise in enterprise security architecture and compliance'),
('USR-007', 'David', 'Kim', 'david.kim@globalconnect-consulting.com', '+82-2-555-0701', '+82-10-555-701', '1987-04-12', 'Male', '2023-07-15 10:45:00', '2024-10-28 15:20:00', 'Active', 'Business', 'ko', 'Asia/Seoul', 'International business consultant specializing in digital transformation and market expansion'),
('USR-008', 'Astrid', 'Bergström', 'astrid.bergstrom@nextgen-platforms.com', '+46-8-555-0801', '+46-70-555-801', '1991-09-28', 'Female', '2023-08-20 13:15:00', '2024-10-29 11:40:00', 'Active', 'Individual', 'sv', 'Europe/Stockholm', 'Product manager focusing on platform strategy and user engagement optimization'),
('USR-009', 'Robert', 'Davis', 'robert.davis@techsupport.com', '+1-512-555-0901', '+1-512-555-0902', '1983-01-14', 'Male', '2023-09-10 15:30:00', '2024-10-26 18:55:00', 'Active', 'Individual', 'en', 'America/Chicago', 'Technical support specialist with expertise in customer service automation and support systems'),
('USR-010', 'Maria', 'Santos', 'maria.santos@fintech-innovations.com', '+55-11-555-1001', '+55-11-9555-1001', '1989-06-08', 'Female', '2023-10-05 09:00:00', '2024-10-30 14:25:00', 'Active', 'Business', 'pt', 'America/Sao_Paulo', 'Financial technology analyst with certifications in financial modeling and blockchain technology'),
('USR-011', 'Thomas', 'Mueller', 'thomas.mueller@architecture-design.com', '+49-89-555-1101', '+49-172-555-1101', '1979-10-30', 'Male', '2023-11-18 11:20:00', '2024-10-27 16:10:00', 'Active', 'VIP', 'de', 'Europe/Berlin', 'Enterprise solutions architect with specialization in microservices and distributed systems'),
('USR-012', 'Sophie', 'Martin', 'sophie.martin@creative-content.com', '+33-1-555-1201', '+33-6-555-1201', '1992-02-17', 'Female', '2023-12-03 14:45:00', '2024-10-29 08:30:00', 'Active', 'Individual', 'fr', 'Europe/Paris', 'Content strategist specializing in video production and digital marketing campaigns'),
('USR-013', 'James', 'Wilson', 'james.wilson@devops-solutions.com', '+1-206-555-1301', '+1-206-555-1302', '1985-11-05', 'Male', '2024-01-15 16:10:00', '2024-10-28 19:45:00', 'Active', 'Business', 'en', 'America/Los_Angeles', 'DevOps engineer with certifications in Kubernetes, AWS, and infrastructure automation'),
('USR-014', 'Elena', 'Popova', 'elena.popova@research-lab.com', '+7-495-555-1401', '+7-926-555-1401', '1986-08-20', 'Female', '2024-02-20 12:00:00', '2024-10-30 13:15:00', 'Active', 'Enterprise', 'ru', 'Europe/Moscow', 'Research scientist with PhD in Computer Science, focusing on artificial intelligence and natural language processing'),
('USR-015', 'Carlos', 'Mendoza', 'carlos.mendoza@mobile-innovations.com', '+52-55-555-1501', '+52-1-555-1501', '1988-12-03', 'Male', '2024-03-12 10:30:00', '2024-10-26 20:00:00', 'Active', 'Individual', 'es', 'America/Mexico_City', 'Mobile application developer with expertise in iOS and Android native development'),
('USR-016', 'Yuki', 'Tanaka', 'yuki.tanaka@tech-tokyo.com', '+81-3-555-1601', '+81-90-555-1601', '1991-04-15', 'Female', '2024-04-18 13:20:00', '2024-10-29 22:10:00', 'Active', 'Business', 'ja', 'Asia/Tokyo', 'Software engineer specializing in backend systems and API development for fintech applications'),
('USR-017', 'Lucas', 'Anderson', 'lucas.anderson@startup-hub.com', '+61-3-555-1701', '+61-412-555-701', '1993-07-08', 'Male', '2024-05-22 11:45:00', '2024-10-28 14:30:00', 'Pending', 'Individual', 'en', 'Australia/Melbourne', 'Startup founder developing innovative SaaS platforms for small business automation'),
('USR-018', 'Priya', 'Patel', 'priya.patel@data-insights.com', '+91-22-555-1801', '+91-98765-43210', '1987-09-12', 'Female', '2024-06-10 15:30:00', '2024-10-30 18:45:00', 'Active', 'Business', 'en', 'Asia/Kolkata', 'Data analyst with expertise in business intelligence and predictive analytics for e-commerce'),
('USR-019', 'Oliver', 'Schmidt', 'oliver.schmidt@digital-marketing.com', '+43-1-555-1901', '+43-664-555-1901', '1980-11-25', 'Male', '2024-07-14 10:15:00', '2024-10-27 16:20:00', 'Active', 'VIP', 'de', 'Europe/Vienna', 'Digital marketing strategist with Fortune 500 client portfolio and performance marketing expertise'),
('USR-020', 'Amélie', 'Dubois', 'amelie.dubois@innovation-lab.com', '+33-4-555-2001', '+33-7-555-2001', '1994-03-22', 'Female', '2024-08-05 14:20:00', '2024-10-30 12:45:00', 'Active', 'Individual', 'fr', 'Europe/Paris', 'Innovation researcher developing cutting-edge user interface technologies and interaction design');

-- Insert customer-company relationships (selecting by customer_code and company name)
INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Senior Software Architect', 'Engineering', TRUE, '2020-01-15'
FROM customers c, companies comp
WHERE c.customer_code = 'USR-001' AND comp.company_name = 'InnovaTech Global';

INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Digital Transformation Lead', 'Consulting', TRUE, '2019-06-01'
FROM customers c, companies comp
WHERE c.customer_code = 'USR-002' AND comp.company_name = 'Digital Solutions Pro';

INSERT INTO customer_companies (customer_id, company_id, position, department, is_primary, start_date)
SELECT c.id, comp.id, 'Cloud Infrastructure Manager', 'Operations', TRUE, '2021-03-10'
FROM customers c, companies comp
WHERE c.customer_code = 'USR-003' AND comp.company_name = 'CloudFirst Technologies';

-- Insert addresses
INSERT INTO addresses (customer_id, address_type, street_address, apartment, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '1 Hacker Way', 'Suite 1000', 'San Francisco', 'California', '94103', 'United States', TRUE
FROM customers WHERE customer_code = 'USR-001';

INSERT INTO addresses (customer_id, address_type, street_address, apartment, city, state_province, postal_code, country, is_default)
SELECT id, 'Home', '2850 Telegraph Ave', 'Apt 15B', 'Berkeley', 'California', '94705', 'United States', FALSE
FROM customers WHERE customer_code = 'USR-001';

INSERT INTO addresses (customer_id, address_type, street_address, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '25 Canada Square', 'London', 'England', 'E14 5LQ', 'United Kingdom', TRUE
FROM customers WHERE customer_code = 'USR-002';

INSERT INTO addresses (customer_id, address_type, street_address, city, state_province, postal_code, country, is_default)
SELECT id, 'Work', '161 Bay Street', 'Toronto', 'Ontario', 'M5J 2S1', 'Canada', TRUE
FROM customers WHERE customer_code = 'USR-003';

-- Insert communication preferences
INSERT INTO communication_preferences (customer_id, email_marketing, sms_notifications, phone_calls, newsletter, promotional_offers, event_invitations, preferred_contact_method, contact_frequency)
SELECT id, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, 'Email', 'Weekly'
FROM customers WHERE customer_code IN ('USR-001', 'USR-002', 'USR-003');

INSERT INTO communication_preferences (customer_id, email_marketing, sms_notifications, phone_calls, newsletter, promotional_offers, event_invitations, preferred_contact_method, contact_frequency)
SELECT id, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, 'SMS', 'Monthly'
FROM customers WHERE customer_code IN ('USR-004', 'USR-005', 'USR-006');

-- Insert customer segment assignments
INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'AI System Auto-Assignment', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('USR-001', 'USR-004', 'USR-014') AND cs.segment_name = 'Enterprise Accounts';

INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'Account Management Team', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('USR-002', 'USR-006', 'USR-011', 'USR-019') AND cs.segment_name = 'Premium Subscribers';

INSERT INTO customer_segment_assignments (customer_id, segment_id, assigned_by, is_active)
SELECT c.id, cs.id, 'Marketing Automation', TRUE
FROM customers c, customer_segments cs
WHERE c.customer_code IN ('USR-001', 'USR-003', 'USR-005', 'USR-013', 'USR-016') AND cs.segment_name = 'Tech Innovators';

-- Insert sample orders
INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'PG-ORD-2024-001', id, '2024-01-25 14:30:00', 'Delivered', 25750.00, 'USD', 'Credit Card', 'Paid', 'Digital Delivery', 'Enterprise AI platform license with premium support package'
FROM customers WHERE customer_code = 'USR-001';

INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'PG-ORD-2024-002', id, '2024-02-18 11:45:00', 'Delivered', 12900.00, 'GBP', 'Bank Transfer', 'Paid', 'Digital Delivery', 'Digital transformation consulting package with UX audit and implementation'
FROM customers WHERE customer_code = 'USR-002';

INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, currency, payment_method, payment_status, shipping_method, notes)
SELECT 'PG-ORD-2024-003', id, '2024-03-15 09:20:00', 'Processing', 18500.00, 'CAD', 'Credit Card', 'Pending', 'Digital Delivery', 'Cloud infrastructure setup and migration services with 24/7 monitoring'
FROM customers WHERE customer_code = 'USR-003';

-- Insert customer interactions
INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Meeting', 'AI Platform Integration Planning', 'Strategic planning session for enterprise AI platform integration with existing systems and workflow optimization', '2024-10-25 14:30:00', 90, 'Positive', 'Alexandra Chen', 'Video Conference'
FROM customers WHERE customer_code = 'USR-001';

INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Email', 'UX Audit Results and Recommendations', 'Comprehensive review of UX audit findings with detailed recommendations for digital transformation improvements', '2024-10-28 10:15:00', 45, 'Follow-up Required', 'Marcus Thompson', 'Email'
FROM customers WHERE customer_code = 'USR-002';

INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, duration_minutes, outcome, agent_name, channel)
SELECT id, 'Phone', 'Cloud Migration Progress Review', 'Weekly progress review call discussing cloud migration milestones and addressing technical implementation challenges', '2024-10-29 16:00:00', 60, 'Positive', 'Sarah Mitchell', 'Phone'
FROM customers WHERE customer_code = 'USR-003';

-- Insert support tickets
INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to, resolution)
SELECT 'PG-TKT-2024-001', id, 'API Rate Limiting Configuration', 'Request for custom API rate limiting configuration for high-volume enterprise integration with third-party systems', 'Medium', 'Resolved', 'Technical Configuration', 'DevOps Team', 'Successfully configured custom rate limits and implemented monitoring dashboard for API usage tracking.'
FROM customers WHERE customer_code = 'USR-001';

INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to)
SELECT 'PG-TKT-2024-002', id, 'Advanced Analytics Dashboard Feature', 'Feature request for advanced analytics dashboard with custom KPI tracking and automated reporting capabilities', 'High', 'In Progress', 'Feature Development', 'Product Team'
FROM customers WHERE customer_code = 'USR-002';

INSERT INTO support_tickets (ticket_number, customer_id, subject, description, priority, status, category, assigned_to)
SELECT 'PG-TKT-2024-003', id, 'Multi-Region Deployment Assistance', 'Technical assistance needed for multi-region cloud deployment setup with load balancing and data synchronization', 'High', 'Open', 'Technical Support', 'Cloud Architecture Team'
FROM customers WHERE customer_code = 'USR-003';
