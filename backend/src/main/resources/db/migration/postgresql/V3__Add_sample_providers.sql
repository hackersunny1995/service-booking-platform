-- Add sample provider users
-- Password for all providers: Provider@123
INSERT INTO users (email, password_hash, full_name, phone, role, is_verified, is_active) VALUES
('john.cleaner@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'John Smith', '+1234567001', 'PROVIDER', TRUE, TRUE),
('mike.plumber@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'Mike Johnson', '+1234567002', 'PROVIDER', TRUE, TRUE),
('sarah.electrician@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'Sarah Williams', '+1234567003', 'PROVIDER', TRUE, TRUE),
('tom.carpenter@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'Tom Brown', '+1234567004', 'PROVIDER', TRUE, TRUE),
('lisa.painter@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'Lisa Davis', '+1234567005', 'PROVIDER', TRUE, TRUE),
('raj.technician@homeprime99.com', '$2a$10$rC3WiY8Z/IxQXwIHhqhffeVvLqz8/Z.7qkFNT3rLfZx4yNq0YFGJm', 'Raj Kumar', '+1234567006', 'PROVIDER', TRUE, TRUE);

-- Add provider profiles with business details and location
INSERT INTO provider_profiles (user_id, business_name, description, address, city, state, zip_code, country, latitude, longitude, is_verified, is_available, rating, total_reviews) VALUES
((SELECT id FROM users WHERE email = 'john.cleaner@homeprime99.com'), 'Sparkle Clean Services', 'Professional cleaning services with 10+ years experience', '123 Main St', 'New York', 'NY', '10001', 'USA', 40.7128, -74.0060, TRUE, TRUE, 4.8, 127),
((SELECT id FROM users WHERE email = 'mike.plumber@homeprime99.com'), 'Quick Fix Plumbing', 'Licensed plumber specializing in residential repairs', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 34.0522, -118.2437, TRUE, TRUE, 4.9, 203),
((SELECT id FROM users WHERE email = 'sarah.electrician@homeprime99.com'), 'Bright Sparks Electrical', 'Certified electrician for all your electrical needs', '789 Elm St', 'Chicago', 'IL', '60601', 'USA', 41.8781, -87.6298, TRUE, TRUE, 4.7, 156),
((SELECT id FROM users WHERE email = 'tom.carpenter@homeprime99.com'), 'Woodcraft Carpentry', 'Expert carpenter for furniture and custom woodwork', '321 Pine Rd', 'Houston', 'TX', '77001', 'USA', 29.7604, -95.3698, TRUE, TRUE, 4.6, 89),
((SELECT id FROM users WHERE email = 'lisa.painter@homeprime99.com'), 'ColorPerfect Painting', 'Professional painting services for homes and offices', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 33.4484, -112.0740, TRUE, TRUE, 4.8, 142),
((SELECT id FROM users WHERE email = 'raj.technician@homeprime99.com'), 'TechFix Appliance Repair', 'Expert in all major appliance brands', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 39.9526, -75.1652, TRUE, TRUE, 4.9, 231);

-- Link providers to services they offer
-- John Smith - Cleaning Services (Services 1, 2)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'john.cleaner@homeprime99.com'), 1),
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'john.cleaner@homeprime99.com'), 2);

-- Mike Johnson - Plumbing Services (Services 3, 4)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'mike.plumber@homeprime99.com'), 3),
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'mike.plumber@homeprime99.com'), 4);

-- Sarah Williams - Electrical Services (Services 5, 6)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'sarah.electrician@homeprime99.com'), 5),
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'sarah.electrician@homeprime99.com'), 6);

-- Tom Brown - Carpentry Services (Service 7)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'tom.carpenter@homeprime99.com'), 7);

-- Lisa Davis - Painting Services (Service 8)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'lisa.painter@homeprime99.com'), 8);

-- Raj Kumar - Appliance Repair Services (Service 9)
INSERT INTO provider_services (provider_id, service_id) VALUES
((SELECT pp.id FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'raj.technician@homeprime99.com'), 9);
