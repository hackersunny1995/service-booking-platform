import '../models/booking.dart';
import '../models/booking_request.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class BookingService {
  final ApiService _apiService = ApiService();

  // Create a new booking
  Future<Booking> createBooking(BookingRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConfig.bookings,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception('Failed to create booking: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error creating booking: $e');
      throw Exception('Failed to create booking. Please try again.');
    }
  }

  // Get all bookings for the current customer
  Future<List<Booking>> getCustomerBookings() async {
    try {
      final response = await _apiService.get(ApiConfig.customerBookings);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting customer bookings: $e');
      throw Exception('Failed to load bookings. Please try again.');
    }
  }

  // Get pending bookings
  Future<List<Booking>> getPendingBookings() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.customerBookings}/pending',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pending bookings: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting pending bookings: $e');
      throw Exception('Failed to load pending bookings. Please try again.');
    }
  }

  // Get confirmed bookings
  Future<List<Booking>> getConfirmedBookings() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.customerBookings}/confirmed',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load confirmed bookings: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting confirmed bookings: $e');
      throw Exception('Failed to load confirmed bookings. Please try again.');
    }
  }

  // Get completed bookings
  Future<List<Booking>> getCompletedBookings() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.customerBookings}/completed',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load completed bookings: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting completed bookings: $e');
      throw Exception('Failed to load completed bookings. Please try again.');
    }
  }

  // Get cancelled bookings
  Future<List<Booking>> getCancelledBookings() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.customerBookings}/cancelled',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cancelled bookings: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting cancelled bookings: $e');
      throw Exception('Failed to load cancelled bookings. Please try again.');
    }
  }

  // Get booking by ID
  Future<Booking> getBookingById(int bookingId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.bookings}/$bookingId',
      );

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception('Failed to load booking details: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting booking by ID: $e');
      throw Exception('Failed to load booking details. Please try again.');
    }
  }

  // Cancel a booking
  Future<Booking> cancelBooking(int bookingId) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.bookings}/$bookingId/cancel',
      );

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception('Failed to cancel booking: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error cancelling booking: $e');
      throw Exception('Failed to cancel booking. Please try again.');
    }
  }

  // Get available providers for a service
  Future<List<dynamic>> getAvailableProviders(int serviceId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.bookings}/available-providers/$serviceId',
      );

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('Failed to load available providers: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting available providers: $e');
      throw Exception('Failed to load available providers. Please try again.');
    }
  }
}
