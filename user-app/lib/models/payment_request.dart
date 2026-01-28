class PaymentRequest {
  final int bookingId;
  final double amount;
  final String paymentMethod;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;

  PaymentRequest({
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (razorpayPaymentId != null) 'razorpayPaymentId': razorpayPaymentId,
      if (razorpaySignature != null) 'razorpaySignature': razorpaySignature,
    };
  }
}
