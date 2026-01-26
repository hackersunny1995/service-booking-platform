import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import '../../models/booking_enums.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
  });

  String _formatDateTime() {
    final date = DateFormat('EEEE, MMMM dd, yyyy').format(booking.scheduledDate);
    final time = booking.scheduledTime.substring(0, 5); // HH:mm
    return '$date at $time';
  }

  String _formatCreatedDate() {
    return DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(booking.createdAt);
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _cancelBooking(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelBooking(BuildContext context) async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await bookingProvider.cancelBooking(booking.id);

    // Close loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to bookings list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bookingProvider.errorMessage ?? 'Failed to cancel booking',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: booking.status.statusColor.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: booking.status.statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: booking.status.statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.status.displayName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: booking.status.statusColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Booking ID: #${booking.id}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service details
                  _buildSection(
                    context,
                    'Service Information',
                    Icons.home_repair_service,
                    [
                      _buildDetailRow('Service', booking.serviceName),
                      _buildDetailRow('Scheduled', _formatDateTime()),
                      _buildDetailRow(
                        'Total Amount',
                        '\$${booking.totalAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Provider details
                  _buildSection(
                    context,
                    'Service Provider',
                    Icons.person,
                    [
                      _buildDetailRow('Name', booking.providerName),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Location details
                  _buildSection(
                    context,
                    'Service Location',
                    Icons.location_on,
                    [
                      _buildDetailRow('Address', booking.customerAddress),
                      if (booking.customerLatitude != null &&
                          booking.customerLongitude != null)
                        _buildDetailRow(
                          'Coordinates',
                          '${booking.customerLatitude!.toStringAsFixed(6)}, ${booking.customerLongitude!.toStringAsFixed(6)}',
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Payment details
                  _buildSection(
                    context,
                    'Payment Information',
                    Icons.payment,
                    [
                      _buildDetailRow(
                        'Payment Status',
                        booking.paymentStatus.displayName,
                        valueColor: booking.paymentStatus.statusColor,
                      ),
                      if (booking.paymentId != null)
                        _buildDetailRow('Payment ID', booking.paymentId!),
                    ],
                  ),

                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSection(
                      context,
                      'Additional Notes',
                      Icons.note,
                      [
                        Text(
                          booking.notes!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Booking metadata
                  _buildSection(
                    context,
                    'Booking Details',
                    Icons.info_outline,
                    [
                      _buildDetailRow('Booked On', _formatCreatedDate()),
                      if (booking.updatedAt != null)
                        _buildDetailRow(
                          'Last Updated',
                          DateFormat('MMM dd, yyyy \'at\' hh:mm a')
                              .format(booking.updatedAt!),
                        ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  if (booking.canCancel)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showCancelDialog(context),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Booking'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red, width: 2),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),

                  if (booking.canRate) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement rating functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Rating feature coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.star_outline),
                        label: const Text('Rate Service'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (booking.status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.inProgress:
        return Icons.autorenew;
      case BookingStatus.completed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
    }
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
