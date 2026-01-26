import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import '../../models/booking_enums.dart';
import '../../widgets/booking_card.dart';
import 'booking_details_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Load bookings when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).loadMyBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Booking> _filterBookingsByStatus(
    List<Booking> bookings,
    BookingStatus? status,
  ) {
    if (status == null) return bookings; // All bookings
    return bookings.where((b) => b.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoadingBookings) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your bookings...'),
                ],
              ),
            );
          }

          if (bookingProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bookingProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        bookingProvider.loadMyBookings();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // All bookings
              _buildBookingsList(
                bookingProvider.myBookings,
                'No bookings yet',
                'Start booking services to see them here',
              ),

              // Pending bookings
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.myBookings,
                  BookingStatus.pending,
                ),
                'No pending bookings',
                'All your pending bookings will appear here',
              ),

              // Confirmed bookings
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.myBookings,
                  BookingStatus.confirmed,
                ),
                'No confirmed bookings',
                'All your confirmed bookings will appear here',
              ),

              // Completed bookings
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.myBookings,
                  BookingStatus.completed,
                ),
                'No completed bookings',
                'All your completed bookings will appear here',
              ),

              // Cancelled bookings
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.myBookings,
                  BookingStatus.cancelled,
                ),
                'No cancelled bookings',
                'All your cancelled bookings will appear here',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingsList(
    List<Booking> bookings,
    String emptyTitle,
    String emptyMessage,
  ) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Browse Services'),
              ),
            ],
          ),
        ),
      );
    }

    // Sort bookings by date (most recent first)
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<BookingProvider>(context, listen: false)
            .loadMyBookings();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BookingCard(
              booking: booking,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      booking: booking,
                    ),
                  ),
                ).then((_) {
                  // Reload bookings when returning from details
                  Provider.of<BookingProvider>(context, listen: false)
                      .loadMyBookings();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
