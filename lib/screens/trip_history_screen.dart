import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  String _selectedPeriod = 'all';
  
  final List<Map<String, String>> _periods = [
    {'value': 'all', 'label': 'All'},
    {'value': 'today', 'label': 'Today'},
    {'value': 'week', 'label': 'Last 7 Days'},
    {'value': 'month', 'label': 'This Month'},
    {'value': 'year', 'label': 'This Year'},
  ];

  @override
  void initState() {
    super.initState();
    // Load data after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadTrips();
      }
    });
  }

  Future<void> _loadTrips() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      final driverId = authProvider.currentUser!.driverIdAsInt;
      // Set period first to ensure proper filtering
      tripProvider.setPeriod(_selectedPeriod);
      await Future.wait([
        tripProvider.loadCompletedTrips(driverId),
        earningsProvider.loadDriverEarnings(driverId, _selectedPeriod), // Load earnings for selected period
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Navigate back to home screen using NavigationProvider
            final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            navigationProvider.navigateToHome();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          padding: const EdgeInsets.all(16),
        ),
        title: Text(
          'Trip History',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadTrips,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer2<TripProvider, EarningsProvider>(
        builder: (context, tripProvider, earningsProvider, child) {
          if (tripProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tripProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load trips',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your internet connection and try again',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTrips,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final completedTrips = tripProvider.filteredCompletedTrips;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Summary Card
                _buildTripSummaryCard(tripProvider, earningsProvider),
                const SizedBox(height: 16),
                
                // Filter Section
                _buildFilterSection(),
                const SizedBox(height: 16),
                
                // Completed Trips List
                Text(
                  'Trip History',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Show trips or empty state
                if (completedTrips.isEmpty)
                  _buildEmptyTripsState()
                else
                  ...completedTrips.map((trip) => _buildTripCard(trip)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripSummaryCard(TripProvider tripProvider, EarningsProvider earningsProvider) {
    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getPeriodDisplayName(_selectedPeriod)} Trip Summary',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Define card data - show filtered trips data based on selected period
              final cards = [
                {
                  'title': 'Total Trips',
                  'value': '${tripProvider.filteredCompletedTrips.length}', // Use filtered trips
                  'icon': Icons.local_taxi,
                  'color': AppTheme.primaryBlue,
                },
                {
                  'title': 'Total Earnings',
                  'value': '₹${earningsProvider.totalEarnings.toStringAsFixed(0)}',
                  'icon': Icons.account_balance_wallet,
                  'color': AppTheme.accentGreen,
                },
                {
                  'title': 'Today',
                  'value': '₹${earningsProvider.todayEarnings.toStringAsFixed(0)}',
                  'icon': Icons.today,
                  'color': AppTheme.accentOrange,
                },
                {
                      'title': 'Last 7 Days',
                  'value': '₹${earningsProvider.weeklyTotal.toStringAsFixed(0)}',
                  'icon': Icons.date_range,
                  'color': AppTheme.accentPurple,
                },
              ];

              // Always use 2 cards per row for better layout
              return Column(
                children: [
                  // First row
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          cards[0]['title'] as String,
                          cards[0]['value'] as String,
                          cards[0]['icon'] as IconData,
                          cards[0]['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          cards[1]['title'] as String,
                          cards[1]['value'] as String,
                          cards[1]['icon'] as IconData,
                          cards[1]['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Second row
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          cards[2]['title'] as String,
                          cards[2]['value'] as String,
                          cards[2]['icon'] as IconData,
                          cards[2]['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          cards[3]['title'] as String,
                          cards[3]['value'] as String,
                          cards[3]['icon'] as IconData,
                          cards[3]['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.accentGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip #${trip.tripId}',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Text(
                        trip.clientName,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Completed',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${trip.amount}',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Trip Details
            _buildTripDetailRow(
              Icons.location_on,
              'From',
              trip.startLocation,
              Colors.grey[600]!,
            ),
            const SizedBox(height: 8),
            _buildTripDetailRow(
              Icons.location_on,
              'To',
              trip.endLocation,
              Colors.grey[600]!,
            ),
            
            if (trip.startTime != null && trip.endTime != null) ...[
              const SizedBox(height: 8),
              _buildTripDetailRow(
                Icons.access_time,
                'Duration',
                trip.formattedDuration,
                Colors.grey[600]!,
              ),
            ],
            
            if (trip.distanceKm != null) ...[
              const SizedBox(height: 8),
              _buildTripDetailRow(
                Icons.straighten,
                'Distance',
                trip.formattedDistance,
                Colors.grey[600]!,
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Trip Date
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[500], size: 16),
                const SizedBox(width: 8),
                Text(
                  'Completed on ${_formatDate(trip.endTime ?? trip.createdAt)}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildEmptyTripsState() {
    return AppCard(
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No trips found for ${_getPeriodLabel(_selectedPeriod)}',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed trips will appear here',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodLabel(String period) {
    switch (period) {
      case 'today':
        return 'today';
      case 'week':
        return 'this week';
      case 'month':
        return 'this month';
      case 'year':
        return 'this year';
      default:
        return 'the selected period';
    }
  }

  String _getPeriodDisplayName(String period) {
    switch (period) {
      case 'all':
        return 'All';
      case 'today':
        return 'Today';
      case 'week':
        return 'Last 7 Days';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'All';
    }
  }

  Widget _buildFilterSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Period',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedPeriod,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _periods.map((period) {
              return DropdownMenuItem<String>(
                value: period['value'],
                child: Text(period['label']!),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if (newValue != null && newValue != _selectedPeriod) {
                setState(() {
                  _selectedPeriod = newValue;
                });
                
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final tripProvider = Provider.of<TripProvider>(context, listen: false);
                
                if (authProvider.currentUser != null) {
                  final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
                  // Set period first to ensure proper filtering
                  tripProvider.setPeriod(_selectedPeriod);
                  // Reload trips and earnings data for the new period
                  await Future.wait([
                    tripProvider.loadCompletedTrips(authProvider.currentUser!.driverIdAsInt),
                    earningsProvider.loadDriverEarnings(authProvider.currentUser!.driverIdAsInt, _selectedPeriod),
                  ]);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}