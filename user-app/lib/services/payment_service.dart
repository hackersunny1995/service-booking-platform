import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment.dart';
import '../models/payment_request.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();
  late Razorpay _razorpay;

  // Initialize Razorpay
  void initializeRazorpay({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function() onWalletSelection,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      onSuccess(response);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      onFailure(response);
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      onWalletSelection();
    });
  }

  // Create payment order on backend
  Future<Payment> createPaymentOrder({
    required int bookingId,
    required double amount,
  }) async {
    try {
      final request = PaymentRequest(
        bookingId: bookingId,
        amount: amount,
        paymentMethod: 'RAZORPAY',
      );

      final response = await _apiService.post(
        '${ApiConfig.payments}/create',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return Payment.fromJson(response.data);
      } else {
        throw Exception('Failed to create payment order');
      }
    } catch (e) {
      print('Error creating payment order: $e');
      throw Exception('Failed to create payment order. Please try again.');
    }
  }

  // Open Razorpay checkout
  void openCheckout({
    required double amount,
    required String orderId,
    required String name,
    required String email,
    required String phone,
    required String description,
  }) {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // TODO: Move to config/env
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'Homeprime99',
      'description': description,
      'order_id': orderId,
      'prefill': {
        'contact': phone,
        'email': email,
        'name': name,
      },
      'theme': {
        'color': '#FF6B35',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
      throw Exception('Failed to open payment gateway');
    }
  }

  // Verify payment on backend
  Future<Payment> verifyPayment({
    required int bookingId,
    required double amount,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final request = PaymentRequest(
        bookingId: bookingId,
        amount: amount,
        paymentMethod: 'RAZORPAY',
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      final response = await _apiService.post(
        '${ApiConfig.payments}/verify',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Payment.fromJson(response.data);
      } else {
        throw Exception('Payment verification failed');
      }
    } catch (e) {
      print('Error verifying payment: $e');
      throw Exception('Payment verification failed. Please contact support.');
    }
  }

  // Get payments for a booking
  Future<List<Payment>> getBookingPayments(int bookingId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.payments}/booking/$bookingId',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments');
      }
    } catch (e) {
      print('Error getting booking payments: $e');
      throw Exception('Failed to load payments. Please try again.');
    }
  }

  // Get payment by ID
  Future<Payment> getPaymentById(int paymentId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.payments}/$paymentId',
      );

      if (response.statusCode == 200) {
        return Payment.fromJson(response.data);
      } else {
        throw Exception('Failed to load payment details');
      }
    } catch (e) {
      print('Error getting payment: $e');
      throw Exception('Failed to load payment details. Please try again.');
    }
  }

  // Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}
