# Homeprime99 Backend - Testing Guide

## ✅ Backend Status: **RUNNING**

The Homeprime99 backend is successfully running on `http://localhost:8080`

### Server Information
- **Application**: Homeprime99 Backend v1.0.0
- **Port**: 8080
- **Database**: H2 In-Memory (for testing)
- **Profile**: h2
- **Status**: ✅ Started successfully in 4.969 seconds

---

## 📍 Important URLs

### API Documentation
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Docs JSON**: http://localhost:8080/api-docs

### Database Console
- **H2 Console**: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:homeprime99`
  - Username: `sa`
  - Password: (leave blank)

---

## 🧪 API Testing

### 1. Authentication Endpoints

#### Register a Customer
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "customer@test.com",
    "password": "password123",
    "fullName": "Test Customer",
    "phone": "+919876543210",
    "role": "CUSTOMER",
    "city": "Mumbai"
  }'
```

**Response:**
```json
{
    "accessToken": "eyJhbGci...",
    "tokenType": "Bearer",
    "userId": 2,
    "email": "customer@test.com",
    "fullName": "Test Customer",
    "role": "CUSTOMER"
}
```

#### Register a Service Provider
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "provider@test.com",
    "password": "password123",
    "fullName": "Test Provider",
    "phone": "+919876543211",
    "role": "PROVIDER",
    "city": "Mumbai",
    "bio": "Professional home services provider",
    "experienceYears": 5
  }'
```

#### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "customer@test.com",
    "password": "password123"
  }'
```

---

### 2. Service Categories

#### Get All Categories ✅ TESTED & WORKING
```bash
curl -X GET http://localhost:8080/api/categories \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:** 8 categories loaded:
1. Home Cleaning
2. Plumbing
3. Electrical
4. Carpentry
5. Painting
6. Appliance Repair
7. Pest Control
8. Beauty & Wellness

---

### 3. Services

#### Get All Services
```bash
curl -X GET http://localhost:8080/api/services \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Get Services by Category
```bash
curl -X GET http://localhost:8080/api/services/category/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### 4. Providers

#### Get Available Providers
```bash
curl -X GET http://localhost:8080/api/providers \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Get Nearby Providers
```bash
curl -X GET "http://localhost:8080/api/providers/nearby?latitude=19.0760&longitude=72.8777" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### 5. Bookings

#### Create a Booking (Customer only)
```bash
curl -X POST http://localhost:8080/api/bookings \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "providerId": 1,
    "serviceId": 1,
    "scheduledDate": "2026-01-30",
    "scheduledTime": "10:00:00",
    "customerAddress": "123 Main Street, Mumbai",
    "customerLatitude": 19.0760,
    "customerLongitude": 72.8777,
    "notes": "Please call before arriving"
  }'
```

#### Get My Bookings
```bash
curl -X GET http://localhost:8080/api/bookings/customer \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### 6. Admin Endpoints

#### Get Dashboard Statistics
```bash
curl -X GET http://localhost:8080/api/admin/dashboard \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

#### Get All Users
```bash
curl -X GET http://localhost:8080/api/admin/users \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

---

## 🔑 Test Credentials

### Pre-loaded Admin Account
```
Email: admin@homeprime99.com
Password: admin123
Note: There's a BCrypt hash issue - please register a new admin if login fails
```

### Registered Test Accounts
```
Customer:
Email: customer@test.com
Password: password123
Token: eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzY5MjU0OTIxLCJleHAiOjE3NjkzNDEzMjF9.nkm4T65Nrfk7if6ugEYhQrFnv3007nL3lHqIy7pX09N4yays_1CVtOO1xqBhPfVv5yagQH6BQWNWQ4SLIw0drw
```

---

## 📊 Database Inspection

### Access H2 Console
1. Open browser: http://localhost:8080/h2-console
2. Enter connection details:
   - JDBC URL: `jdbc:h2:mem:homeprime99`
   - Username: `sa`
   - Password: (leave blank)
3. Click Connect

### Sample Queries
```sql
-- View all users
SELECT * FROM users;

-- View all service categories
SELECT * FROM service_categories;

-- View all services
SELECT * FROM services;

-- View bookings
SELECT * FROM bookings;
```

---

## 🚀 Available API Endpoints

### Authentication
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user

### Service Categories
- `GET /api/categories` - Get active categories
- `GET /api/categories/all` - Get all categories (Admin)
- `GET /api/categories/{id}` - Get category by ID
- `POST /api/categories` - Create category (Admin)
- `PUT /api/categories/{id}` - Update category (Admin)
- `DELETE /api/categories/{id}` - Delete category (Admin)

### Services
- `GET /api/services` - Get active services
- `GET /api/services/category/{categoryId}` - Get services by category
- `GET /api/services/{id}` - Get service by ID
- `POST /api/services` - Create service (Admin)
- `PUT /api/services/{id}` - Update service (Admin)
- `DELETE /api/services/{id}` - Delete service (Admin)

### Providers
- `GET /api/providers` - Get available providers
- `GET /api/providers/all` - Get all providers (Admin)
- `GET /api/providers/nearby?latitude=X&longitude=Y` - Get nearby providers
- `GET /api/providers/{id}` - Get provider by ID
- `GET /api/providers/me` - Get current provider profile
- `PUT /api/providers/me` - Update provider profile
- `PUT /api/providers/me/location` - Update location
- `PUT /api/providers/me/availability` - Update availability
- `PUT /api/providers/{id}/approve` - Approve provider (Admin)

### Bookings
- `GET /api/bookings` - Get current user's bookings
- `GET /api/bookings/all` - Get all bookings (Admin)
- `GET /api/bookings/customer` - Get customer bookings
- `GET /api/bookings/provider` - Get provider bookings
- `GET /api/bookings/{id}` - Get booking by ID
- `POST /api/bookings` - Create booking (Customer)
- `PUT /api/bookings/{id}/status` - Update booking status
- `DELETE /api/bookings/{id}` - Cancel booking

### Reviews
- `GET /api/reviews/provider/{providerId}` - Get provider reviews
- `GET /api/reviews/booking/{bookingId}` - Get review by booking
- `GET /api/reviews/{id}` - Get review by ID
- `POST /api/reviews` - Create review (Customer)
- `GET /api/reviews/provider/{providerId}/rating` - Get average rating

### Payments
- `GET /api/payments/booking/{bookingId}` - Get booking payments
- `GET /api/payments/{id}` - Get payment by ID
- `GET /api/payments/all` - Get all payments (Admin)
- `POST /api/payments/create` - Create payment order
- `POST /api/payments/verify` - Verify payment
- `POST /api/payments/{id}/refund` - Refund payment (Admin)

### Chat
- `GET /api/chat/booking/{bookingId}` - Get chat messages
- `PUT /api/chat/booking/{bookingId}/read` - Mark messages as read
- `GET /api/chat/unread-count` - Get unread message count

### Notifications
- `GET /api/notifications` - Get user notifications
- `GET /api/notifications/unread-count` - Get unread count
- `PUT /api/notifications/{id}/read` - Mark as read
- `PUT /api/notifications/read-all` - Mark all as read
- `POST /api/notifications/fcm-token` - Update FCM token

### Admin
- `GET /api/admin/dashboard` - Get dashboard stats
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/{id}/status` - Update user status

---

## 🎯 Testing Workflow

### 1. Test User Registration & Login
```bash
# Register
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"pass123","fullName":"Test User","phone":"+911234567890","role":"CUSTOMER"}'

# Save the token from response
export TOKEN="paste_your_token_here"

# Test authenticated endpoint
curl -X GET http://localhost:8080/api/categories \
  -H "Authorization: Bearer $TOKEN"
```

### 2. Browse Services
```bash
# Get categories
curl -X GET http://localhost:8080/api/categories -H "Authorization: Bearer $TOKEN"

# Get services for a category
curl -X GET http://localhost:8080/api/services/category/1 -H "Authorization: Bearer $TOKEN"
```

### 3. Find Providers
```bash
# Get all providers
curl -X GET http://localhost:8080/api/providers -H "Authorization: Bearer $TOKEN"

# Get nearby providers (Mumbai coordinates)
curl -X GET "http://localhost:8080/api/providers/nearby?latitude=19.0760&longitude=72.8777" \
  -H "Authorization: Bearer $TOKEN"
```

---

## 🐛 Known Issues

1. **Services Endpoint Error**: Services endpoint returns Hibernate proxy serialization error
   - **Workaround**: Use category-specific services endpoint
   - **Fix needed**: Add Jackson Hibernate module or DTO mapping

2. **Admin Login**: Pre-seeded admin password hash may not match
   - **Workaround**: Register a new user with ADMIN role
   - **Fix needed**: Generate correct BCrypt hash

---

## 🛑 Stopping the Backend

```bash
# Find the process
lsof -ti:8080

# Kill the process
kill -9 $(lsof -ti:8080)

# Or kill specific PID
kill 58227
```

---

## 📝 Next Steps

1. **Fix Serialization Issues**: Add proper DTO mapping or configure Jackson for Hibernate
2. **Fix Admin Login**: Generate correct BCrypt hash for admin password
3. **Test All Endpoints**: Systematically test each endpoint in Swagger UI
4. **WebSocket Testing**: Test chat and location tracking features
5. **Integration Testing**: Test complete booking workflow
6. **Switch to PostgreSQL**: Once testing complete, switch to PostgreSQL for production

---

## ✅ Verified Working Features

- ✅ User Registration (Customer & Provider)
- ✅ JWT Authentication
- ✅ Service Categories API
- ✅ Database Migrations
- ✅ H2 Database
- ✅ Swagger Documentation
- ✅ Spring Security
- ✅ CORS Configuration

---

## 📚 Documentation

- Swagger UI: http://localhost:8080/swagger-ui.html
- API Specification: http://localhost:8080/api-docs
- Database Console: http://localhost:8080/h2-console

---

**Homeprime99 Backend v1.0.0** - Built with Spring Boot 3.2.1
