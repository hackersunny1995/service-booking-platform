-- Insert default admin user (password: admin123)
-- BCrypt hash for 'admin123'
INSERT INTO users (email, password_hash, full_name, phone, role, is_verified, is_active)
VALUES ('admin@homeprime99.com', '$2a$10$8.H7IJ9xGPHG6DFO2CyaWOZ7h7.aMU5pjY9qZC1q7sHqZ9PqYqYqK', 'Homeprime99 Admin', '+1234567890', 'ADMIN', TRUE, TRUE);

-- Insert service categories
INSERT INTO service_categories (name, description, icon_url, is_active) VALUES
('Home Cleaning', 'Professional home cleaning services including deep cleaning, regular cleaning, and sanitization', 'https://via.placeholder.com/150', TRUE),
('Plumbing', 'Expert plumbing services for repairs, installations, and maintenance', 'https://via.placeholder.com/150', TRUE),
('Electrical', 'Licensed electrician services for installations, repairs, and wiring', 'https://via.placeholder.com/150', TRUE),
('Carpentry', 'Professional carpentry services for furniture repair and custom woodwork', 'https://via.placeholder.com/150', TRUE),
('Painting', 'Interior and exterior painting services by skilled professionals', 'https://via.placeholder.com/150', TRUE),
('Appliance Repair', 'Repair services for washing machines, refrigerators, ACs, and more', 'https://via.placeholder.com/150', TRUE),
('Pest Control', 'Effective pest control and fumigation services', 'https://via.placeholder.com/150', TRUE),
('Beauty & Wellness', 'At-home beauty and wellness services including salon and spa treatments', 'https://via.placeholder.com/150', TRUE);

-- Insert sample services for Home Cleaning category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Deep Cleaning', 'Comprehensive deep cleaning of your entire home', 99.99, 180, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Home Cleaning';

INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Regular Cleaning', 'Regular maintenance cleaning for your home', 49.99, 90, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Home Cleaning';

-- Insert sample services for Plumbing category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Tap/Faucet Installation', 'Installation and repair of taps and faucets', 29.99, 60, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Plumbing';

INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Toilet Repair', 'Complete toilet repair and maintenance service', 39.99, 90, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Plumbing';

-- Insert sample services for Electrical category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Switch/Socket Installation', 'Installation of electrical switches and sockets', 19.99, 45, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Electrical';

INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Ceiling Fan Installation', 'Professional ceiling fan installation service', 34.99, 60, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Electrical';

-- Insert sample services for Carpentry category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Furniture Repair', 'Repair and restoration of furniture', 44.99, 120, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Carpentry';

-- Insert sample services for Painting category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Interior Wall Painting', 'Professional interior wall painting service', 149.99, 240, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Painting';

-- Insert sample services for Appliance Repair category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Washing Machine Repair', 'Repair service for all types of washing machines', 59.99, 90, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Appliance Repair';

-- Insert sample services for Pest Control category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'General Pest Control', 'Complete pest control treatment for your home', 79.99, 120, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Pest Control';

-- Insert sample services for Beauty & Wellness category
INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Haircut (Male)', 'Professional haircut service at your doorstep', 19.99, 30, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Beauty & Wellness';

INSERT INTO services (category_id, name, description, base_price, duration_minutes, image_url, is_active)
SELECT id, 'Facial', 'Rejuvenating facial treatment at home', 49.99, 60, 'https://via.placeholder.com/300', TRUE
FROM service_categories WHERE name = 'Beauty & Wellness';
