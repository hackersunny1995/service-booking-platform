import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/provider_card.dart';

class ProviderSelectionStep extends StatefulWidget {
  const ProviderSelectionStep({super.key});

  @override
  State<ProviderSelectionStep> createState() => _ProviderSelectionStepState();
}

class _ProviderSelectionStepState extends State<ProviderSelectionStep> {
  String _sortBy = 'distance'; // distance, rating, experience

  List _getSortedProviders(BookingProvider bookingProvider) {
    List providers = List.from(bookingProvider.availableProviders);

    switch (_sortBy) {
      case 'distance':
        providers.sort((a, b) {
          if (a.distance == null && b.distance == null) return 0;
          if (a.distance == null) return 1;
          if (b.distance == null) return -1;
          return a.distance!.compareTo(b.distance!);
        });
        break;

      case 'rating':
        providers.sort((a, b) {
          int ratingCompare = b.averageRating.compareTo(a.averageRating);
          if (ratingCompare != 0) return ratingCompare;
          return b.totalReviews.compareTo(a.totalReviews);
        });
        break;

      case 'experience':
        providers.sort((a, b) {
          int expA = a.experienceYears ?? 0;
          int expB = b.experienceYears ?? 0;
          return expB.compareTo(expA);
        });
        break;
    }

    return providers;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        if (bookingProvider.isLoadingProviders) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading available providers...'),
              ],
            ),
          );
        }

        if (bookingProvider.availableProviders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Providers Available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No service providers are available in your area at the moment. Please try a different location or service.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      bookingProvider.loadAvailableProviders();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final sortedProviders = _getSortedProviders(bookingProvider);

        return Column(
          children: [
            // Header with sort options
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Provider',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${bookingProvider.availableProviders.length} available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sort options
                  Row(
                    children: [
                      Text(
                        'Sort by:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildSortChip('Distance', 'distance'),
                              const SizedBox(width: 8),
                              _buildSortChip('Rating', 'rating'),
                              const SizedBox(width: 8),
                              _buildSortChip('Experience', 'experience'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Providers list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sortedProviders.length,
                itemBuilder: (context, index) {
                  final provider = sortedProviders[index];
                  final isSelected = bookingProvider.selectedProvider?.id == provider.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProviderCard(
                      provider: provider,
                      isSelected: isSelected,
                      onTap: () {
                        bookingProvider.setSelectedProvider(provider);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sortBy = value;
          });
        }
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
        width: isSelected ? 1.5 : 1,
      ),
    );
  }
}
