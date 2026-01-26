# Service Booking Platform - Backend

Spring Boot REST API for an Urban Clap-like service booking platform.

## Features

- JWT-based authentication and authorization
- Role-based access control (Customer, Provider, Admin)
- Service and provider management
- Booking system with status tracking
- Real-time chat via WebSocket
- Real-time location tracking
- Payment processing integration
- Review and rating system
- Push notifications via Firebase Cloud Messaging
- Comprehensive admin dashboard

## Tech Stack

- **Framework**: Spring Boot 3.2.1
- **Database**: PostgreSQL 15+
- **Security**: Spring Security + JWT
- **Real-time**: WebSocket (STOMP)
- **Notifications**: Firebase Cloud Messaging
- **API Documentation**: SpringDoc OpenAPI (Swagger)
- **Build Tool**: Maven

## Prerequisites

- Java 17 or higher
- PostgreSQL 15 or higher
- Maven 3.6+
- Firebase project (for push notifications)

## Database Setup

1. Install PostgreSQL

2. Create database:
```sql
CREATE DATABASE servicebooking;
```

3. Update `application.properties` with your database credentials:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/servicebooking
spring.datasource.username=your_username
spring.datasource.password=your_password
```

## Configuration

### 1. JWT Secret

Generate a secure JWT secret key (at least 256 bits) and update in `application.properties`:
```properties
jwt.secret=your-256-bit-secret-key
```

### 2. Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Generate a private key (Settings > Service Accounts > Generate new private key)
3. Save the JSON file as `src/main/resources/firebase-adminsdk.json`

### 3. CORS Configuration

Update allowed origins in `SecurityConfig.java` if deploying to production:
```java
configuration.setAllowedOrigins(List.of("your-frontend-url"));
```

## Running the Application

### Using Maven

```bash
cd backend
mvn spring-boot:run
```

### Using JAR

```bash
mvn clean package
java -jar target/service-booking-backend-1.0.0.jar
```

The application will start on `http://localhost:8080`

## API Documentation

Once the application is running, access Swagger UI at:
```
http://localhost:8080/swagger-ui.html
```

API docs JSON:
```
http://localhost:8080/api-docs
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Services
- `GET /api/categories` - Get all service categories
- `GET /api/services` - Get all services
- `GET /api/services/category/{categoryId}` - Get services by category
- `POST /api/admin/services` - Create service (Admin only)

### Providers
- `GET /api/providers` - Get available providers
- `GET /api/providers/nearby?latitude=X&longitude=Y` - Get nearby providers
- `PUT /api/providers/me` - Update provider profile
- `PUT /api/providers/me/location` - Update location
- `PUT /api/providers/me/availability` - Update availability

### Bookings
- `POST /api/bookings` - Create booking
- `GET /api/bookings/customer` - Get customer bookings
- `GET /api/bookings/provider` - Get provider bookings
- `PUT /api/bookings/{id}/status` - Update booking status
- `DELETE /api/bookings/{id}` - Cancel booking

### Reviews
- `POST /api/reviews` - Create review
- `GET /api/reviews/provider/{providerId}` - Get provider reviews

### Payments
- `POST /api/payments/create` - Create payment order
- `POST /api/payments/verify` - Verify payment

### Chat
- `GET /api/chat/booking/{bookingId}` - Get chat messages
- WebSocket: `/app/chat/{bookingId}/send` - Send message

### Location Tracking
- WebSocket: `/app/location/{bookingId}/update` - Update location

### Notifications
- `GET /api/notifications` - Get user notifications
- `POST /api/notifications/fcm-token` - Update FCM token

### Admin
- `GET /api/admin/dashboard` - Get dashboard stats
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/{id}/status` - Update user status

## WebSocket Endpoints

### Chat
- Connect: `/ws`
- Subscribe: `/topic/booking/{bookingId}/chat`
- Send: `/app/chat/{bookingId}/send`

### Location Tracking
- Subscribe: `/topic/booking/{bookingId}/location`
- Send: `/app/location/{bookingId}/update`

## Default Admin Account

After running migrations, use these credentials to login as admin:
```
Email: admin@servicebooking.com
Password: admin123
```

**Important**: Change this password in production!

## Database Migrations

Flyway migrations are in `src/main/resources/db/migration/`:
- `V1__Initial_schema.sql` - Database schema
- `V2__Seed_data.sql` - Sample data and admin user

## Testing

Run tests:
```bash
mvn test
```

## Building for Production

```bash
mvn clean package -DskipTests
```

The JAR file will be in `target/` directory.

## Environment Variables

For production deployment, use environment variables instead of hardcoding in `application.properties`:

```bash
export DB_URL=jdbc:postgresql://your-db-host:5432/servicebooking
export DB_USERNAME=your_username
export DB_PASSWORD=your_password
export JWT_SECRET=your-production-secret
export FIREBASE_KEY_PATH=/path/to/firebase-adminsdk.json
```

## Troubleshooting

### Database Connection Failed
- Ensure PostgreSQL is running
- Verify database credentials in `application.properties`
- Check if database `servicebooking` exists

### Firebase Initialization Failed
- Verify Firebase service account JSON file exists
- Check file path in `application.properties`
- Application will run without Firebase (notifications disabled)

### Port Already in Use
Change server port in `application.properties`:
```properties
server.port=8081
```

## Project Structure

```
src/main/java/com/servicebooking/
├── config/          # Configuration classes
├── controller/      # REST controllers
├── dto/            # Data Transfer Objects
├── exception/      # Custom exceptions
├── model/          # Entity classes
├── repository/     # JPA repositories
├── security/       # Security & JWT
├── service/        # Business logic
└── websocket/      # WebSocket handlers
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

## License

MIT License
