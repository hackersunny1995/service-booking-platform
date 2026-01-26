import '../config/api_config.dart';
import '../models/auth_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save auth data
      await _storageService.saveAuthData(
        token: authResponse.accessToken,
        userId: authResponse.userId,
        email: authResponse.email,
        fullName: authResponse.fullName,
        role: authResponse.role,
      );

      return authResponse;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String? city,
    String? address,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone,
          'role': 'CUSTOMER',
          'city': city,
          'address': address,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save auth data
      await _storageService.saveAuthData(
        token: authResponse.accessToken,
        userId: authResponse.userId,
        email: authResponse.email,
        fullName: authResponse.fullName,
        role: authResponse.role,
      );

      return authResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearAuthData();
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }
}
