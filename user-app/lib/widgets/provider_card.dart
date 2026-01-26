import 'package:flutter/material.dart';
import '../models/provider.dart';

class ProviderCard extends StatelessWidget {
  final Provider provider;
  final bool isSelected;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and name
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: provider.isAvailable
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.shade300,
                    child: Text(
                      provider.fullName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: provider.isAvailable
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Name and availability
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.fullName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: provider.isAvailable
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              provider.isAvailable ? 'Available' : 'Busy',
                              style: TextStyle(
                                fontSize: 13,
                                color: provider.isAvailable
                                    ? Colors.green.shade700
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rating and reviews
              Row(
                children: [
                  Text(
                    provider.getRatingStars(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    provider.averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${provider.totalReviews} reviews)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bio (if available)
              if (provider.bio != null && provider.bio!.isNotEmpty) ...[
                Text(
                  provider.bio!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Info chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Experience
                  _buildInfoChip(
                    icon: Icons.work_outline,
                    label: provider.getExperienceText(),
                    context: context,
                  ),

                  // Total bookings
                  _buildInfoChip(
                    icon: Icons.assignment_outlined,
                    label: '${provider.totalBookings} bookings',
                    context: context,
                  ),

                  // Distance (if available)
                  if (provider.distance != null)
                    _buildInfoChip(
                      icon: Icons.location_on_outlined,
                      label: provider.getDistanceText(),
                      context: context,
                      highlighted: true,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required BuildContext context,
    bool highlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: highlighted
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
              color: highlighted
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
