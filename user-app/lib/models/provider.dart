class Provider {
  final int id;
  final int userId;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;
  final String? bio;
  final int? experienceYears;
  final double serviceRadiusKm;
  final double averageRating;
  final int totalReviews;
  final int totalBookings;
  final double? latitude;
  final double? longitude;
  final bool isAvailable;
  final bool isApproved;
  final double? distance; // Calculated distance from user location

  Provider({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
    this.bio,
    this.experienceYears,
    required this.serviceRadiusKm,
    required this.averageRating,
    required this.totalReviews,
    required this.totalBookings,
    this.latitude,
    this.longitude,
    required this.isAvailable,
    required this.isApproved,
    this.distance,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      userId: json['user']?['id'] ?? json['userId'] ?? 0,
      fullName: json['user']?['fullName'] ?? json['fullName'] ?? 'Unknown',
      email: json['user']?['email'] ?? json['email'] ?? '',
      phone: json['user']?['phone'] ?? json['phone'] ?? '',
      profileImage: json['user']?['profileImage'] ?? json['profileImage'],
      bio: json['bio'],
      experienceYears: json['experienceYears'],
      serviceRadiusKm: (json['serviceRadiusKm'] as num?)?.toDouble() ?? 10.0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isAvailable: json['isAvailable'] ?? false,
      isApproved: json['isApproved'] ?? false,
      distance: json['distance']?.toDouble(),
    );
  }

  Provider copyWith({double? distance}) {
    return Provider(
      id: id,
      userId: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      profileImage: profileImage,
      bio: bio,
      experienceYears: experienceYears,
      serviceRadiusKm: serviceRadiusKm,
      averageRating: averageRating,
      totalReviews: totalReviews,
      totalBookings: totalBookings,
      latitude: latitude,
      longitude: longitude,
      isAvailable: isAvailable,
      isApproved: isApproved,
      distance: distance ?? this.distance,
    );
  }

  String getRatingStars() {
    final fullStars = averageRating.floor();
    final hasHalfStar = (averageRating - fullStars) >= 0.5;

    String stars = '⭐' * fullStars;
    if (hasHalfStar) {
      stars += '½';
    }
    return stars;
  }

  String getExperienceText() {
    if (experienceYears == null || experienceYears == 0) {
      return 'New provider';
    }
    return '$experienceYears ${experienceYears == 1 ? 'year' : 'years'} experience';
  }

  String getDistanceText() {
    if (distance == null) {
      return '';
    }
    if (distance! < 1.0) {
      return '${(distance! * 1000).toStringAsFixed(0)}m away';
    }
    return '${distance!.toStringAsFixed(1)} km away';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'bio': bio,
      'experienceYears': experienceYears,
      'serviceRadiusKm': serviceRadiusKm,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'totalBookings': totalBookings,
      'latitude': latitude,
      'longitude': longitude,
      'isAvailable': isAvailable,
      'isApproved': isApproved,
      'distance': distance,
    };
  }
}
