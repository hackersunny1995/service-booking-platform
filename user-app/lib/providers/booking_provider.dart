import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/booking_request.dart';
import '../models/provider.dart';
import '../models/service.dart';
import '../services/booking_service.dart';
import '../services/provider_service.dart';
import '../services/location_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final ProviderService _providerService = ProviderService();
  final LocationService _locationService = LocationService();

  // Booking flow state
  int _currentStep = 0;
  ServiceModel? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _customerAddress;
  double? _customerLatitude;
  double? _customerLongitude;
  Provider? _selectedProvider;
  String? _notes;

  // Providers list
  List<Provider> _availableProviders = [];
  bool _isLoadingProviders = false;

  // Booking state
  bool _isCreatingBooking = false;
  Booking? _createdBooking;
  String? _errorMessage;

  // My bookings state
  List<Booking> _myBookings = [];
  bool _isLoadingBookings = false;

  // Getters
  int get currentStep => _currentStep;
  ServiceModel? get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String? get customerAddress => _customerAddress;
  double? get customerLatitude => _customerLatitude;
  double? get customerLongitude => _customerLongitude;
  Provider? get selectedProvider => _selectedProvider;
  String? get notes => _notes;
  List<Provider> get availableProviders => _availableProviders;
  bool get isLoadingProviders => _isLoadingProviders;
  bool get isCreatingBooking => _isCreatingBooking;
  Booking? get createdBooking => _createdBooking;
  String? get errorMessage => _errorMessage;
  List<Booking> get myBookings => _myBookings;
  bool get isLoadingBookings => _isLoadingBookings;

  // Initialize booking flow with service
  void initializeBooking(ServiceModel service) {
    _selectedService = service;
    _currentStep = 0;
    _selectedDate = null;
    _selectedTime = null;
    _customerAddress = null;
    _customerLatitude = null;
    _customerLongitude = null;
    _selectedProvider = null;
    _notes = null;
    _availableProviders = [];
    _createdBooking = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Reset booking flow
  void resetBooking() {
    _currentStep = 0;
    _selectedService = null;
    _selectedDate = null;
    _selectedTime = null;
    _customerAddress = null;
    _customerLatitude = null;
    _customerLongitude = null;
    _selectedProvider = null;
    _notes = null;
    _availableProviders = [];
    _createdBooking = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Set selected time
  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Set address
  void setAddress(String address, {double? latitude, double? longitude}) {
    _customerAddress = address;
    _customerLatitude = latitude;
    _customerLongitude = longitude;
    notifyListeners();
  }

  // Set address from current location
  Future<bool> setAddressFromCurrentLocation() async {
    try {
      _errorMessage = null;
      notifyListeners();

      final locationData = await _locationService.getCurrentLocationWithAddress();

      if (locationData != null) {
        _customerAddress = locationData['address'];
        _customerLatitude = locationData['latitude'];
        _customerLongitude = locationData['longitude'];
        notifyListeners();
        return true;
      }

      _errorMessage = 'Could not get current location';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Get coordinates from address
  Future<bool> getCoordinatesFromAddress(String address) async {
    try {
      final coords = await _locationService.getCoordinatesFromAddress(address);

      if (coords != null) {
        _customerLatitude = coords['latitude'];
        _customerLongitude = coords['longitude'];
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print('Error getting coordinates: $e');
      return false;
    }
  }

  // Set selected provider
  void setSelectedProvider(Provider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  // Set notes
  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  // Load available providers
  Future<void> loadAvailableProviders() async {
    if (_selectedService == null) {
      _errorMessage = 'No service selected';
      notifyListeners();
      return;
    }

    _isLoadingProviders = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // If we have user location, get nearby providers with distance
      if (_customerLatitude != null && _customerLongitude != null) {
        _availableProviders = await _providerService.getProvidersWithDistance(
          serviceId: _selectedService!.id,
          userLatitude: _customerLatitude!,
          userLongitude: _customerLongitude!,
        );
      } else {
        // Otherwise, get all providers for the service
        _availableProviders = await _providerService.getProvidersByService(
          _selectedService!.id,
        );
      }

      _isLoadingProviders = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoadingProviders = false;
      notifyListeners();
    }
  }

  // Move to next step
  Future<bool> nextStep() async {
    // Validate current step before moving
    String? validationError = _validateCurrentStep();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    // Load providers when moving from address step to provider step
    if (_currentStep == 1) {
      await loadAvailableProviders();
    }

    if (_currentStep < 3) {
      _currentStep++;
      _errorMessage = null;
      notifyListeners();
      return true;
    }

    return false;
  }

  // Move to previous step
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Go to specific step
  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      _currentStep = step;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Validate current step
  String? _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Date/Time step
        if (_selectedDate == null) {
          return 'Please select a date';
        }
        if (_selectedTime == null) {
          return 'Please select a time';
        }
        // Validate using BookingRequest validation
        if (_selectedService != null) {
          final tempRequest = BookingRequest(
            providerId: 1, // Dummy value for validation
            serviceId: _selectedService!.id,
            scheduledDate: _selectedDate!,
            scheduledTime: _selectedTime!,
            customerAddress: 'dummy', // Dummy value for validation
          );
          return tempRequest.validateDateTime();
        }
        return null;

      case 1: // Address step
        if (_customerAddress == null || _customerAddress!.trim().isEmpty) {
          return 'Please enter or select an address';
        }
        if (_customerAddress!.trim().length < 10) {
          return 'Please enter a complete address';
        }
        return null;

      case 2: // Provider step
        if (_selectedProvider == null) {
          return 'Please select a service provider';
        }
        return null;

      case 3: // Confirmation step
        // All validations already done in previous steps
        return null;

      default:
        return null;
    }
  }

  // Create booking
  Future<bool> createBooking() async {
    // Final validation
    if (_selectedService == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        _customerAddress == null ||
        _selectedProvider == null) {
      _errorMessage = 'Missing required booking information';
      notifyListeners();
      return false;
    }

    _isCreatingBooking = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = BookingRequest(
        providerId: _selectedProvider!.id,
        serviceId: _selectedService!.id,
        scheduledDate: _selectedDate!,
        scheduledTime: _selectedTime!,
        customerAddress: _customerAddress!,
        customerLatitude: _customerLatitude,
        customerLongitude: _customerLongitude,
        notes: _notes,
      );

      // Validate request
      if (!request.validate()) {
        throw Exception('Invalid booking details. Please check all fields.');
      }

      _createdBooking = await _bookingService.createBooking(request);

      _isCreatingBooking = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isCreatingBooking = false;
      notifyListeners();
      return false;
    }
  }

  // Load my bookings
  Future<void> loadMyBookings() async {
    _isLoadingBookings = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myBookings = await _bookingService.getCustomerBookings();
      _isLoadingBookings = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoadingBookings = false;
      notifyListeners();
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(int bookingId) async {
    try {
      _errorMessage = null;
      notifyListeners();

      await _bookingService.cancelBooking(bookingId);

      // Reload bookings
      await loadMyBookings();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
