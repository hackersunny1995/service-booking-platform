import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/service.dart';
import 'steps/date_time_step.dart';
import 'steps/address_step.dart';
import 'steps/provider_selection_step.dart';
import 'steps/confirmation_step.dart';
import '../../widgets/step_indicator.dart';

class BookingFlowScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingFlowScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Initialize booking flow with selected service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false)
          .initializeBooking(widget.service);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepContinue(BookingProvider bookingProvider) async {
    final success = await bookingProvider.nextStep();
    if (success) {
      _pageController.animateToPage(
        bookingProvider.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Show error if validation failed
      if (bookingProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onStepCancel(BookingProvider bookingProvider) {
    if (bookingProvider.currentStep > 0) {
      bookingProvider.previousStep();
      _pageController.animateToPage(
        bookingProvider.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Exit booking flow
      Navigator.pop(context);
    }
  }

  List<String> get _stepTitles => [
        'Date & Time',
        'Address',
        'Select Provider',
        'Confirm Booking',
      ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Book ${widget.service.name}'),
            elevation: 0,
          ),
          body: Column(
            children: [
              // Step indicator
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: StepIndicator(
                  currentStep: bookingProvider.currentStep,
                  stepTitles: _stepTitles,
                ),
              ),

              // Page view with steps
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swipe
                  children: const [
                    DateTimeStep(),
                    AddressStep(),
                    ProviderSelectionStep(),
                    ConfirmationStep(),
                  ],
                ),
              ),

              // Bottom navigation buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _onStepCancel(bookingProvider),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          bookingProvider.currentStep == 0 ? 'Cancel' : 'Back',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Continue button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: bookingProvider.isLoadingProviders ||
                                bookingProvider.isCreatingBooking
                            ? null
                            : () {
                                if (bookingProvider.currentStep == 3) {
                                  // Last step - create booking
                                  _createBooking(bookingProvider);
                                } else {
                                  // Continue to next step
                                  _onStepContinue(bookingProvider);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: bookingProvider.isCreatingBooking
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                bookingProvider.currentStep == 3
                                    ? 'Confirm Booking'
                                    : 'Continue',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createBooking(BookingProvider bookingProvider) async {
    final success = await bookingProvider.createBooking();

    if (success && mounted) {
      // Navigate to success screen
      Navigator.pushReplacementNamed(
        context,
        '/booking-success',
        arguments: bookingProvider.createdBooking,
      );
    } else if (mounted) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bookingProvider.errorMessage ?? 'Failed to create booking',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
