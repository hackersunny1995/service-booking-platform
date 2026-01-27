-- Create provider profiles for demo providers
-- These profiles link to provider users created via registration API

-- Provider 1: John Smith - Cleaning Services
INSERT INTO provider_profiles (user_id, business_name, description, address, city, state, zip_code, country, latitude, longitude, is_verified, is_available, rating, total_reviews)
SELECT
    u.id,
    'Sparkle Clean Services',
    'Professional cleaning services with 10+ years experience',
    '123 Main St',
    'New York',
    'NY',
    '10001',
    'USA',
    40.7128,
    -74.0060,
    TRUE,
    TRUE,
    4.8,
    127
FROM users u
WHERE u.email = 'john.cleaner@demo.com' AND u.role = 'PROVIDER';

-- Provider 2: Mike Johnson - Plumbing
INSERT INTO provider_profiles (user_id, business_name, description, address, city, state, zip_code, country, latitude, longitude, is_verified, is_available, rating, total_reviews)
SELECT
    u.id,
    'Quick Fix Plumbing',
    'Licensed plumber specializing in residential repairs',
    '456 Oak Ave',
    'Los Angeles',
    'CA',
    '90001',
    'USA',
    34.0522,
    -118.2437,
    TRUE,
    TRUE,
    4.9,
    203
FROM users u
WHERE u.email = 'mike.plumber@demo.com' AND u.role = 'PROVIDER';

-- Provider 3: Sarah Williams - Electrical
INSERT INTO provider_profiles (user_id, business_name, description, address, city, state, zip_code, country, latitude, longitude, is_verified, is_available, rating, total_reviews)
SELECT
    u.id,
    'Bright Sparks Electrical',
    'Certified electrician for all your electrical needs',
    '789 Elm St',
    'Chicago',
    'IL',
    '60601',
    'USA',
    41.8781,
    -87.6298,
    TRUE,
    TRUE,
    4.7,
    156
FROM users u
WHERE u.email = 'sarah.electrician@demo.com' AND u.role = 'PROVIDER';

-- Link providers to services (service_id 1 = Deep Cleaning, 2 = Regular Cleaning, etc.)
-- John Smith offers cleaning services
INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 1 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'john.cleaner@demo.com';

INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 2 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'john.cleaner@demo.com';

-- Mike Johnson offers plumbing services
INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 3 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'mike.plumber@demo.com';

INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 4 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'mike.plumber@demo.com';

-- Sarah Williams offers electrical services
INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 5 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'sarah.electrician@demo.com';

INSERT INTO provider_services (provider_id, service_id)
SELECT pp.id, 6 FROM provider_profiles pp JOIN users u ON pp.user_id = u.id WHERE u.email = 'sarah.electrician@demo.com';
