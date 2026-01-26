import '../models/provider.dart';
import '../config/api_config.dart';
import 'api_service.dart';
import 'location_service.dart';

class ProviderService {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  // Get all providers for a specific service
  Future<List<Provider>> getProvidersByService(int serviceId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.providers}/service/$serviceId',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Provider.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load providers: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting providers by service: $e');
      throw Exception('Failed to load providers. Please try again.');
    }
  }

  // Get nearby providers for a specific service with user location
  Future<List<Provider>> getNearbyProviders({
    required int serviceId,
    required double userLatitude,
    required double userLongitude,
    double? radiusKm,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.providers}/nearby',
        queryParameters: {
          'serviceId': serviceId,
          'latitude': userLatitude,
          'longitude': userLongitude,
          if (radiusKm != null) 'radius': radiusKm,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Provider> providers = data.map((json) => Provider.fromJson(json)).toList();

        // Calculate and add distance to each provider
        for (int i = 0; i < providers.length; i++) {
          if (providers[i].latitude != null && providers[i].longitude != null) {
            double distance = _locationService.calculateDistance(
              userLatitude,
              userLongitude,
              providers[i].latitude!,
              providers[i].longitude!,
            );
            providers[i] = providers[i].copyWith(distance: distance);
          }
        }

        // Sort by distance (nearest first)
        providers.sort((a, b) {
          if (a.distance == null && b.distance == null) return 0;
          if (a.distance == null) return 1;
          if (b.distance == null) return -1;
          return a.distance!.compareTo(b.distance!);
        });

        return providers;
      } else {
        throw Exception('Failed to load nearby providers: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting nearby providers: $e');
      throw Exception('Failed to load nearby providers. Please try again.');
    }
  }

  // Get providers by service with distance calculation (fallback if backend doesn't have nearby endpoint)
  Future<List<Provider>> getProvidersWithDistance({
    required int serviceId,
    required double userLatitude,
    required double userLongitude,
  }) async {
    try {
      List<Provider> providers = await getProvidersByService(serviceId);

      // Calculate distance for each provider
      List<Provider> providersWithDistance = [];
      for (var provider in providers) {
        if (provider.latitude != null && provider.longitude != null) {
          double distance = _locationService.calculateDistance(
            userLatitude,
            userLongitude,
            provider.latitude!,
            provider.longitude!,
          );

          // Only include providers within their service radius
          if (_locationService.isWithinServiceRadius(
            userLatitude,
            userLongitude,
            provider.latitude!,
            provider.longitude!,
            provider.serviceRadiusKm,
          )) {
            providersWithDistance.add(provider.copyWith(distance: distance));
          }
        }
      }

      // Sort by distance (nearest first)
      providersWithDistance.sort((a, b) {
        if (a.distance == null && b.distance == null) return 0;
        if (a.distance == null) return 1;
        if (b.distance == null) return -1;
        return a.distance!.compareTo(b.distance!);
      });

      return providersWithDistance;
    } catch (e) {
      print('Error getting providers with distance: $e');
      rethrow;
    }
  }

  // Get provider by ID
  Future<Provider> getProviderById(int providerId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.providers}/$providerId',
      );

      if (response.statusCode == 200) {
        return Provider.fromJson(response.data);
      } else {
        throw Exception('Failed to load provider details: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error getting provider by ID: $e');
      throw Exception('Failed to load provider details. Please try again.');
    }
  }

  // Search providers by name or location
  Future<List<Provider>> searchProviders(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.providers}/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Provider.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search providers: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error searching providers: $e');
      throw Exception('Failed to search providers. Please try again.');
    }
  }

  // Get top-rated providers for a service
  Future<List<Provider>> getTopRatedProviders(int serviceId, {int limit = 10}) async {
    try {
      List<Provider> providers = await getProvidersByService(serviceId);

      // Filter only approved and available providers
      providers = providers.where((p) => p.isApproved && p.isAvailable).toList();

      // Sort by rating (highest first)
      providers.sort((a, b) {
        // Primary sort: average rating
        int ratingCompare = b.averageRating.compareTo(a.averageRating);
        if (ratingCompare != 0) return ratingCompare;

        // Secondary sort: total reviews (more reviews = more reliable)
        return b.totalReviews.compareTo(a.totalReviews);
      });

      // Return top N providers
      return providers.take(limit).toList();
    } catch (e) {
      print('Error getting top-rated providers: $e');
      rethrow;
    }
  }
}
