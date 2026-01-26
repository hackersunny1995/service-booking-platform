import 'booking_enums.dart';

class Booking {
  final int id;
  final int customerId;
  final int providerId;
  final int serviceId;
  final String serviceName;
  final String providerName;
  final DateTime scheduledDate;
  final String scheduledTime; // Format: "HH:mm:ss"
  final BookingStatus status;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final String? paymentId;
  final String customerAddress;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.serviceId,
    required this.serviceName,
    required this.providerName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentId,
    required this.customerAddress,
    this.customerLatitude,
    this.customerLongitude,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      customerId: json['customer']?['id'] ?? json['customerId'] ?? 0,
      providerId: json['provider']?['id'] ?? json['providerId'] ?? 0,
      serviceId: json['service']?['id'] ?? json['serviceId'] ?? 0,
      serviceName: json['service']?['name'] ?? json['serviceName'] ?? 'Unknown Service',
      providerName: json['provider']?['fullName'] ?? json['providerName'] ?? 'Unknown Provider',
      scheduledDate: DateTime.parse(json['scheduledDate']),
      scheduledTime: json['scheduledTime'],
      status: BookingStatus.fromJson(json['status']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentStatus: PaymentStatus.fromJson(json['paymentStatus']),
      paymentId: json['paymentId'],
      customerAddress: json['customerAddress'],
      customerLatitude: json['customerLatitude']?.toDouble(),
      customerLongitude: json['customerLongitude']?.toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'providerId': providerId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'providerName': providerName,
      'scheduledDate': scheduledDate.toIso8601String().split('T')[0],
      'scheduledTime': scheduledTime,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus.toJson(),
      'paymentId': paymentId,
      'customerAddress': customerAddress,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String getScheduledDateTimeDisplay() {
    final dateStr = '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
    final timeStr = scheduledTime.substring(0, 5); // HH:mm from HH:mm:ss
    return '$dateStr at $timeStr';
  }

  bool get canCancel {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

  bool get canRate {
    return status == BookingStatus.completed;
  }
}
