import 'package:flutter/material.dart';

class BookingRequest {
  final int providerId;
  final int serviceId;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final String customerAddress;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? notes;

  BookingRequest({
    required this.providerId,
    required this.serviceId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.customerAddress,
    this.customerLatitude,
    this.customerLongitude,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'serviceId': serviceId,
      'scheduledDate': scheduledDate.toIso8601String().split('T')[0], // YYYY-MM-DD
      'scheduledTime': '${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}:00', // HH:mm:ss
      'customerAddress': customerAddress,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'notes': notes,
    };
  }

  bool validate() {
    if (providerId <= 0) return false;
    if (serviceId <= 0) return false;
    if (customerAddress.trim().isEmpty) return false;
    if (customerAddress.trim().length < 10) return false;

    // Validate date is in the future
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    if (bookingDateTime.isBefore(now)) return false;

    return true;
  }

  String? validateDateTime() {
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    if (bookingDateTime.isBefore(now)) {
      return 'Booking date and time must be in the future';
    }

    // Check if time is within business hours (8 AM - 8 PM)
    if (scheduledTime.hour < 8 || scheduledTime.hour >= 20) {
      return 'Please select a time between 8:00 AM and 8:00 PM';
    }

    // Check if booking is at least 2 hours from now
    final twoHoursFromNow = now.add(const Duration(hours: 2));
    if (bookingDateTime.isBefore(twoHoursFromNow)) {
      return 'Please book at least 2 hours in advance';
    }

    // Check if booking is not more than 30 days in advance
    final thirtyDaysFromNow = now.add(const Duration(days: 30));
    if (bookingDateTime.isAfter(thirtyDaysFromNow)) {
      return 'Bookings can only be made up to 30 days in advance';
    }

    return null;
  }

  String? validateAddress() {
    if (customerAddress.trim().isEmpty) {
      return 'Please enter a service address';
    }
    if (customerAddress.trim().length < 10) {
      return 'Please enter a complete address';
    }
    if (customerAddress.length > 500) {
      return 'Address is too long (max 500 characters)';
    }
    return null;
  }

  String? validateProvider() {
    if (providerId <= 0) {
      return 'Please select a service provider';
    }
    return null;
  }
}
