import 'package:flutter/material.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  bool get isAuthenticated => _authResponse != null;

  // Get user from auth response
  UserModel? get user {
    if (_authResponse == null) return null;
    return UserModel(
      id: _authResponse!.userId,
      email: _authResponse!.email,
      fullName: _authResponse!.fullName,
      phone: '',
      role: _authResponse!.role,
    );
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String? city,
    String? address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        city: city,
        address: address,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _authResponse = null;
    notifyListeners();
  }

  // Check login status
  Future<bool> checkLoginStatus() async {
    return await _authService.isLoggedIn();
  }

  // Load saved auth data
  Future<void> loadSavedAuthData() async {
    _authResponse = await _authService.getSavedAuthData();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
