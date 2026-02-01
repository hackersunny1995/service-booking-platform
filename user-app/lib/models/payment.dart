import 'payment_status.dart';

class Payment {
  final int id;
  final int bookingId;
  final double amount;
  final String paymentMethod;
  final String? transactionId;
  final String? razorpayOrderId;
  final PaymentStatus status;
  final String createdAt;

  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
    this.razorpayOrderId,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['booking']?['id'] ?? json['bookingId'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      razorpayOrderId: json['razorpayOrderId'],
      status: PaymentStatus.fromString(json['status']),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'razorpayOrderId': razorpayOrderId,
      'status': status.name,
      'createdAt': createdAt,
    };
  }
}
