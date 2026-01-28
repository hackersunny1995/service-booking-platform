import 'dart:js' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/payment.dart';
import '../models/payment_request.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class PaymentServiceWeb {
  final ApiService _apiService = ApiService();

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

  // Open Razorpay checkout using JS interop
  void openCheckout({
    required double amount,
    required String orderId,
    required String name,
    required String email,
    required String phone,
    required String description,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(Map<String, dynamic>) onFailure,
  }) {
    if (!kIsWeb) {
      throw Exception('This payment method is only available on web');
    }

    // Create options object for Razorpay
    final options = js.JsObject.jsify({
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': (amount * 100).toInt(), // Amount in paise
      'currency': 'INR',
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
      },
      'handler': js.allowInterop((response) {
        // Payment success callback
        final responseMap = {
          'razorpay_payment_id': response['razorpay_payment_id'],
          'razorpay_order_id': response['razorpay_order_id'],
          'razorpay_signature': response['razorpay_signature'],
        };
        onSuccess(responseMap);
      }),
      'modal': js.JsObject.jsify({
        'ondismiss': js.allowInterop(() {
          // Payment dismissed/cancelled
          onFailure({
            'code': 'PAYMENT_CANCELLED',
            'description': 'Payment was cancelled by user',
          });
        }),
      }),
    });

    try {
      // Create Razorpay instance
      final razorpay = js.JsObject(js.context['Razorpay'], [options]);

      // Add error handler
      razorpay['on'] = js.allowInterop((String event, Function callback) {
        if (event == 'payment.failed') {
          return js.allowInterop((response) {
            final errorMap = {
              'code': response['error']['code'] ?? 'PAYMENT_FAILED',
              'description': response['error']['description'] ?? 'Payment failed',
              'source': response['error']['source'] ?? 'unknown',
              'step': response['error']['step'] ?? 'unknown',
              'reason': response['error']['reason'] ?? 'unknown',
            };
            onFailure(errorMap);
          });
        }
      });

      // Open Razorpay checkout
      razorpay.callMethod('open');
    } catch (e) {
      print('Error opening Razorpay: $e');
      onFailure({
        'code': 'INTEGRATION_ERROR',
        'description': 'Failed to open payment gateway: $e',
      });
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
}
