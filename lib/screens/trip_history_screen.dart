import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/loading_widget.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadCompletedTrips();
  }

  Future<void> _loadCompletedTrips() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    if (profileProvider.profile.driverId.isNotEmpty) {
      await tripProvider.loadCompletedTrips(int.parse(profileProvider.profile.driverId));
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
            onPressed: _loadCompletedTrips,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, child) {
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
                    'Error loading trips',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tripProvider.errorMessage!,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCompletedTrips,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final completedTrips = tripProvider.completedTrips;

          if (completedTrips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No completed trips yet',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
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
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Summary Card
                _buildTripSummaryCard(tripProvider),
                const SizedBox(height: 16),
                
                // Completed Trips List
                Text(
                  'Completed Trips',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                
                ...completedTrips.map((trip) => _buildTripCard(trip)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripSummaryCard(TripProvider tripProvider) {
    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Summary',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Trips',
                  '${tripProvider.completedTrips.length}',
                  Icons.local_taxi,
                  AppTheme.primaryBlue,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Total Earnings',
                  '₹${tripProvider.totalEarnings.toStringAsFixed(0)}',
                  Icons.account_balance_wallet,
                  AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Today',
                  '₹${tripProvider.todayEarnings.toStringAsFixed(0)}',
                  Icons.today,
                  AppTheme.accentOrange,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'This Week',
                  '₹${tripProvider.weekEarnings.toStringAsFixed(0)}',
                  Icons.date_range,
                  AppTheme.accentPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
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
                  '₹${trip.fareAmount}',
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
}