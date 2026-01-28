enum PaymentStatus {
  PENDING,
  SUCCESS,
  FAILED,
  REFUNDED;

  String get displayName {
    switch (this) {
      case PaymentStatus.PENDING:
        return 'Pending';
      case PaymentStatus.SUCCESS:
        return 'Success';
      case PaymentStatus.FAILED:
        return 'Failed';
      case PaymentStatus.REFUNDED:
        return 'Refunded';
    }
  }

  static PaymentStatus fromString(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentStatus.PENDING,
    );
  }
}
