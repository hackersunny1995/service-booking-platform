class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final String? profileImage;
  final String? address;
  final String? city;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.profileImage,
    this.address,
    this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phone: json['phone'],
      role: json['role'],
      profileImage: json['profileImage'],
      address: json['address'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'address': address,
      'city': city,
    };
  }
}
