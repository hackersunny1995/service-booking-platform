import 'dart:html' as html;
import 'dart:js_util' as js_util;
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
      onFailure({
        'code': 'PLATFORM_ERROR',
        'description': 'Payment is only available on web platform',
      });
      return;
    }

    try {
      // Check if Razorpay is loaded
      if (js_util.hasProperty(html.window, 'Razorpay') == false) {
        print('ERROR: Razorpay SDK not loaded');
        onFailure({
          'code': 'SDK_NOT_LOADED',
          'description': 'Razorpay SDK is not loaded. Please refresh the page.',
        });
        return;
      }

      print('Razorpay SDK is loaded');
      print('Opening checkout with amount: $amount, orderId: $orderId');

      // Create options object
      final options = js_util.jsify({
        'key': 'rzp_test_SAnYf1YwWqJZD1',
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
        'handler': js_util.allowInterop((response) {
          print('Payment success: $response');
          try {
            final paymentId = js_util.getProperty(response, 'razorpay_payment_id');
            final razorpayOrderId = js_util.getProperty(response, 'razorpay_order_id');
            final signature = js_util.getProperty(response, 'razorpay_signature');

            onSuccess({
              'razorpay_payment_id': paymentId,
              'razorpay_order_id': razorpayOrderId,
              'razorpay_signature': signature,
            });
          } catch (e) {
            print('Error processing payment response: $e');
            onFailure({
              'code': 'PROCESSING_ERROR',
              'description': 'Error processing payment: $e',
            });
          }
        }),
        'modal': {
          'ondismiss': js_util.allowInterop(() {
            print('Payment dismissed by user');
            onFailure({
              'code': 'PAYMENT_CANCELLED',
              'description': 'Payment was cancelled by user',
            });
          }),
        },
      });

      // Get Razorpay constructor
      final razorpayConstructor = js_util.getProperty(html.window, 'Razorpay');

      // Create Razorpay instance
      final razorpay = js_util.callConstructor(razorpayConstructor, [options]);

      // Set up error handler
      js_util.callMethod(razorpay, 'on', [
        'payment.failed',
        js_util.allowInterop((response) {
          print('Payment failed: $response');
          try {
            final error = js_util.getProperty(response, 'error');
            final code = js_util.getProperty(error, 'code') ?? 'PAYMENT_FAILED';
            final description = js_util.getProperty(error, 'description') ?? 'Payment failed';

            onFailure({
              'code': code,
              'description': description,
            });
          } catch (e) {
            print('Error processing payment failure: $e');
            onFailure({
              'code': 'PAYMENT_FAILED',
              'description': 'Payment failed. Please try again.',
            });
          }
        }),
      ]);

      // Open Razorpay checkout
      print('Calling razorpay.open()...');
      js_util.callMethod(razorpay, 'open', []);
      print('Razorpay checkout opened');

    } catch (e, stackTrace) {
      print('Error opening Razorpay: $e');
      print('Stack trace: $stackTrace');
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
