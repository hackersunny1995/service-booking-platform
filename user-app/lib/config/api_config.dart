import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Base URL - Automatically detects platform
  // Web: http://localhost:8080/api
  // Android Emulator: http://10.0.2.2:8080/api
  // iOS Simulator: http://localhost:8080/api
  // Physical Device: http://YOUR_IP_ADDRESS:8080/api
  static String get baseUrl {
    if (kIsWeb) {
      // PRODUCTION: Update this URL after deploying backend to Render
      return 'https://homeprime99-backend.onrender.com/api';
    }
    return 'http://10.0.2.2:8080/api'; // Android emulator
  }

  static String get wsUrl {
    if (kIsWeb) {
      return 'ws://localhost:8080/ws';
    }
    return 'ws://10.0.2.2:8080/ws'; // Android emulator
  }

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Service endpoints
  static const String categories = '/categories';
  static const String services = '/services';
  static const String servicesByCategory = '/services/category';

  // Provider endpoints
  static const String providers = '/providers';
  static const String providersNearby = '/providers/nearby';

  // Booking endpoints
  static const String bookings = '/bookings';
  static const String customerBookings = '/bookings/customer';

  // Review endpoints
  static const String reviews = '/reviews';

  // Payment endpoints
  static const String payments = '/payments';
  static const String createPayment = '/payments/create';
  static const String verifyPayment = '/payments/verify';

  // Chat endpoints
  static const String chat = '/chat';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String updateFcmToken = '/notifications/fcm-token';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
