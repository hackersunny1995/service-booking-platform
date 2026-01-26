# Homeprime99 - Service Booking Platform

A comprehensive Urban Clap-like home services booking platform with complete booking flow, GPS integration, and provider management.

## 🚀 Live Demo

- **Frontend (Flutter Web)**: `https://YOUR-USERNAME.github.io/service-booking-platform/` *(Update after deployment)*
- **Backend API**: `https://homeprime99-backend.onrender.com/api` *(Update after deployment)*

## ✨ Features

### User App (Flutter Web/Mobile)
- ✅ User Authentication (Register/Login with JWT)
- ✅ Browse Service Categories & Services
- ✅ **Complete Booking Flow**
  - Date & Time Selection (8 AM - 8 PM, 2-hour advance booking)
  - Address Input with GPS "Use Current Location" feature
  - Provider Selection (sorted by distance, rating, or experience)
  - Booking Confirmation with summary
  - Animated Success Screen
- ✅ **My Bookings Management**
  - View all bookings with status-based filtering (All, Pending, Confirmed, Completed, Cancelled)
  - Detailed booking view
  - Cancel bookings option
- 📍 **GPS & Location Features**
  - Current location detection with permission handling
  - Address geocoding (address ↔ coordinates)
  - Distance calculation to nearby providers
  - Service radius filtering
- 🎨 Material Design UI with smooth animations

### Backend (Spring Boot)
- ✅ RESTful API with JWT Authentication
- ✅ Supabase PostgreSQL Database
- ✅ Complete Booking System
- ✅ Provider Management with distance sorting
- ✅ Service Categories & Services
- ✅ Review & Rating System Ready
- 🔐 Role-based Access Control (CUSTOMER, PROVIDER, ADMIN)
- 🗄️ Flyway Database Migrations

## 📋 Tech Stack

### Backend
- **Language**: Java 17
- **Framework**: Spring Boot 3.2.1
- **Security**: Spring Security + JWT
- **Database**: PostgreSQL (Supabase)
- **Migrations**: Flyway
- **Build Tool**: Maven 3.9+

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider (ChangeNotifier)
- **HTTP Client**: Dio
- **Maps/GPS**: Geolocator, Geocoding
- **Date/Time**: intl package
- **UI**: Material Design 3

## 🛠️ Local Development

### Prerequisites
- Java 17+
- Flutter SDK 3.x+
- Git

### Backend Setup

1. Clone the repository:
```bash
git clone https://github.com/YOUR-USERNAME/service-booking-platform.git
cd service-booking-platform/backend
```

2. The backend uses H2 in-memory database by default for local development. To run:
```bash
./mvnw spring-boot:run
```

Backend will start on `http://localhost:8080`

**API Endpoints:**
- Base URL: `http://localhost:8080/api`
- Auth: `/auth/login`, `/auth/register`
- Categories: `/categories`
- Services: `/services`, `/services/category/{id}`
- Bookings: `/bookings`, `/bookings/customer`
- Providers: `/providers/service/{id}`

### Frontend Setup

1. Navigate to user-app:
```bash
cd user-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web (Chrome)
flutter run -d chrome

# For Android emulator
flutter run

# For iOS simulator
flutter run -d ios
```

The app will connect to `http://localhost:8080/api` when running on web, or `http://10.0.2.2:8080/api` on Android emulator.

## 🌐 Deployment Guide

### Step 1: Deploy Backend to Render

1. **Create Render Account** at [render.com](https://render.com)

2. **Create New Web Service:**
   - Connect GitHub repository
   - Name: `homeprime99-backend`
   - Environment: `Java`
   - Build Command: `./mvnw clean package -DskipTests`
   - Start Command: `java -Dserver.port=$PORT -Dspring.profiles.active=prod -jar target/*.jar`

3. **Add Environment Variables:**
   ```
   SPRING_PROFILES_ACTIVE=prod
   SPRING_DATASOURCE_URL=jdbc:postgresql://db.jyrpmaqkvpxbcstnogap.supabase.co:5432/postgres
   SPRING_DATASOURCE_USERNAME=postgres
   SPRING_DATASOURCE_PASSWORD=Home@prime#$
   JWT_SECRET=<generate-secure-random-string>
   CORS_ALLOWED_ORIGINS=https://YOUR-USERNAME.github.io
   ```

4. **Deploy** - Render will build and deploy automatically

5. **Note your backend URL** (e.g., `https://homeprime99-backend.onrender.com`)

### Step 2: Update Flutter App Configuration

Edit `user-app/lib/config/api_config.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) {
    // PRODUCTION: Update this with your Render backend URL
    return 'https://homeprime99-backend.onrender.com/api';
  }
  return 'http://10.0.2.2:8080/api'; // Android emulator
}
```

### Step 3: Build Flutter Web App

```bash
cd user-app
flutter build web --release --web-renderer html
```

This creates a production build in `user-app/build/web/`

### Step 4: Deploy to GitHub Pages

**Option 1: Using gh-pages (Recommended)**

```bash
# Install gh-pages globally
npm install -g gh-pages

# Deploy from user-app directory
cd user-app
gh-pages -d build/web
```

**Option 2: Manual GitHub Pages**

1. Copy contents of `user-app/build/web/` to a `docs/` folder in repository root
2. Push to GitHub
3. Go to repository Settings > Pages
4. Set source to `main` branch, `/docs` folder
5. Save

**Option 3: GitHub Actions (Automated)**

Create `.github/workflows/deploy.yml` (provided in project)

### Step 5: Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings > Pages**
3. Source: Select `gh-pages` branch (Option 1) or `main` branch with `/docs` folder (Option 2)
4. Click **Save**

Your app will be live at: `https://YOUR-USERNAME.github.io/service-booking-platform/`

## 📱 Usage Guide

### For Customers

1. **Register/Login**
   - Open the app
   - Click "Sign Up" to create an account
   - Or login with existing credentials

2. **Browse Services**
   - View 8 service categories on home screen
   - Tap any category (e.g., "Plumbing", "Home Cleaning")
   - Browse available services with prices

3. **Book a Service**
   - Select a service
   - Tap "Book Now"
   - Follow 4-step booking wizard:
     - **Step 1**: Select date and time (8 AM - 8 PM slots)
     - **Step 2**: Enter address or tap "Use Current Location"
     - **Step 3**: Choose from nearby providers (sorted by distance/rating/experience)
     - **Step 4**: Review booking details and confirm
   - View animated success screen

4. **Manage Bookings**
   - Tap menu icon (top right) > "My Bookings"
   - Filter by status: All, Pending, Confirmed, Completed, Cancelled
   - Tap any booking to view details
   - Cancel bookings if status is Pending or Confirmed

### Test Credentials

**Admin Account:**
- Email: `admin@homeprime99.com`
- Password: `admin123`

**New Customer:**
- Register with any email and password

## 🗄️ Database Schema

11 tables in Supabase PostgreSQL:

| Table | Description |
|-------|-------------|
| `users` | Customer, Provider, Admin accounts |
| `service_categories` | 8 categories (Plumbing, Cleaning, etc.) |
| `services` | Individual services with pricing |
| `provider_profiles` | Provider details, ratings, location |
| `provider_services` | Services offered by each provider |
| `bookings` | All service bookings |
| `reviews` | Ratings and reviews |
| `payments` | Payment transactions |
| `chat_messages` | In-app messaging |
| `notifications` | Push notifications |
| `provider_availability` | Provider schedules |

## 📂 Project Structure

```
service-booking-platform/
├── backend/                          # Spring Boot Backend
│   ├── src/main/
│   │   ├── java/com/servicebooking/
│   │   │   ├── config/              # Security, CORS config
│   │   │   ├── controller/          # REST Controllers
│   │   │   ├── model/               # JPA Entities
│   │   │   ├── repository/          # Data Access Layer
│   │   │   ├── service/             # Business Logic
│   │   │   ├── dto/                 # DTOs
│   │   │   └── security/            # JWT, Auth
│   │   └── resources/
│   │       ├── db/migration/        # Flyway migrations
│   │       ├── application.properties
│   │       └── application-prod.properties
│   ├── Dockerfile
│   ├── render.yaml
│   └── pom.xml
│
└── user-app/                        # Flutter User App
    ├── lib/
    │   ├── config/                  # API & theme config
    │   ├── models/                  # Data models
    │   ├── services/                # API services
    │   ├── providers/               # State management
    │   ├── screens/                 # UI screens
    │   │   ├── auth/               # Login, Register
    │   │   ├── home/               # Home screen
    │   │   ├── services/           # Service browsing
    │   │   └── booking/            # Booking flow
    │   │       ├── steps/          # Wizard steps
    │   │       ├── booking_flow_screen.dart
    │   │       ├── my_bookings_screen.dart
    │   │       └── booking_success_screen.dart
    │   ├── widgets/                # Reusable widgets
    │   └── main.dart
    └── pubspec.yaml
```

## 🔒 Security Features

- ✅ JWT-based authentication with 24-hour expiration
- ✅ BCrypt password hashing
- ✅ CORS protection
- ✅ Role-based access control (CUSTOMER, PROVIDER, ADMIN)
- ✅ Input validation on both frontend and backend
- ✅ SQL injection prevention via JPA
- ✅ Environment-based configuration

## 🐛 Troubleshooting

### Backend Issues

**Database Connection Error:**
- Verify Supabase credentials in `application-prod.properties`
- Check firewall/network settings

**CORS Error:**
- Update `CORS_ALLOWED_ORIGINS` in Render environment variables
- Ensure it matches your GitHub Pages URL

### Frontend Issues

**API Connection Error:**
- Verify backend URL in `api_config.dart`
- Check if backend is running (Render may sleep on free tier)

**GPS Not Working:**
- Grant location permissions when prompted
- For web: use HTTPS (required for geolocation)

## 📝 TODO / Roadmap

- [ ] Provider App (accept/manage bookings)
- [ ] Admin Panel (manage users, services, bookings)
- [ ] Payment integration (Razorpay/Stripe)
- [ ] Real-time chat
- [ ] Push notifications (FCM)
- [ ] Rating & review system
- [ ] Advanced search & filters

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open Pull Request

## 📄 License

MIT License - See LICENSE file for details

## 📧 Contact

Project Link: [https://github.com/YOUR-USERNAME/service-booking-platform](https://github.com/YOUR-USERNAME/service-booking-platform)

---

Built with ❤️ using Flutter & Spring Boot | Powered by Supabase & Render
