import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_accident_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class NearbyAccidentsWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double radiusKm;
  final Function(Map<String, dynamic>)? onAccidentTap;

  const NearbyAccidentsWidget({
    Key? key,
    this.latitude,
    this.longitude,
    this.radiusKm = 10.0,
    this.onAccidentTap,
  }) : super(key: key);

  @override
  State<NearbyAccidentsWidget> createState() => _NearbyAccidentsWidgetState();
}

class _NearbyAccidentsWidgetState extends State<NearbyAccidentsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNearbyAccidents();
    });
  }

  void _loadNearbyAccidents() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationAccidentProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.driver != null) {
      if (widget.latitude != null && widget.longitude != null) {
        locationProvider.getNearbyAccidents(
          driverId: authProvider.driver!['driver_id'],
          latitude: widget.latitude!,
          longitude: widget.longitude!,
        );
      } else {
        locationProvider.getDriverNearbyAccidents(
          driverId: authProvider.driver!['driver_id'],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationAccidentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading accidents',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadNearbyAccidents,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.nearbyAccidents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No nearby accidents',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'No accidents found within ${provider.searchRadius}km radius',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadNearbyAccidents,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with radius selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Accidents (${provider.nearbyAccidents.length})',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildRadiusSelector(provider),
                ],
              ),
            ),
            
            // Accidents list
            Expanded(
              child: ListView.builder(
                itemCount: provider.nearbyAccidents.length,
                itemBuilder: (context, index) {
                  final accident = provider.nearbyAccidents[index];
                  return _buildAccidentCard(accident);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadiusSelector(LocationAccidentProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<double>(
        value: provider.searchRadius,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 5.0, child: Text('5km')),
          DropdownMenuItem(value: 10.0, child: Text('10km')),
          DropdownMenuItem(value: 15.0, child: Text('15km')),
          DropdownMenuItem(value: 20.0, child: Text('20km')),
        ],
        onChanged: (value) {
          if (value != null) {
            provider.setSearchRadius(value);
            _loadNearbyAccidents();
          }
        },
      ),
    );
  }

  Widget _buildAccidentCard(Map<String, dynamic> accident) {
    final distance = accident['distance_km']?.toString() ?? '0';
    final status = accident['status'] ?? 'pending';
    final createdAt = accident['created_at'] ?? '';
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => widget.onAccidentTap?.call(accident),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      accident['fullname'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Distance and time
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.red[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${distance}km away',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Vehicle info
              if (accident['vehicle'] != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      accident['vehicle'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              
              // Description
              if (accident['description'] != null && accident['description'].isNotEmpty) ...[
                Text(
                  accident['description'],
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              
              // Location
              Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      accident['location'] ?? 'Location not specified',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              // Photos indicator
              if (accident['photos'] != null && (accident['photos'] as List).isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.photo,
                      size: 16,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(accident['photos'] as List).length} photo(s)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'investigating':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}
