class AuthResponse {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String email;
  final String fullName;
  final String role;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'] ?? 'Bearer',
      userId: json['userId'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
    );
  }
}
