import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/service_category.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServiceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ServiceCategory> _categories = [];
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceCategory> get categories => _categories;
  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch categories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.categories);
      _categories = (response.data as List)
          .map((json) => ServiceCategory.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all services
  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.services);
      _services = (response.data as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load services';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch services by category
  Future<void> fetchServicesByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiConfig.servicesByCategory}/$categoryId',
      );
      _services = (response.data as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load services';
      _isLoading = false;
      notifyListeners();
    }
  }
}
