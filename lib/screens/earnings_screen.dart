import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../providers/earnings_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/navigation_provider.dart';
import '../models/earning.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedPeriod = 'all';
  String _selectedTrip = 'all';
  final List<Map<String, String>> _periods = [
    {'value': 'all', 'label': 'All'},
    {'value': 'today', 'label': 'Today'},
    {'value': 'week', 'label': 'This Week'},
    {'value': 'month', 'label': 'This Month'},
    {'value': 'year', 'label': 'This Year'},
  ];
  
  final List<Map<String, String>> _tripFilters = [
    {'value': 'all', 'label': 'All Trips'},
    {'value': '5', 'label': 'Trip #5'},
    {'value': '6', 'label': 'Trip #6'},
    {'value': '7', 'label': 'Trip #7'},
    {'value': '8', 'label': 'Trip #8'},
    {'value': '9', 'label': 'Trip #9'},
  ];

  @override
  void initState() {
    super.initState();
    // Load data after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadEarnings();
      }
    });
  }

  Future<void> _loadEarnings() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
    
    if (profileProvider.profile.driverId.isNotEmpty) {
      await earningsProvider.loadDriverEarnings(
        1, // Using driver ID = 1 for testing
        _selectedPeriod,
      );
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
          'Earnings',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadEarnings,
            icon: const Icon(Icons.refresh, color: Colors.white),
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
      body: Consumer2<EarningsProvider, ProfileProvider>(
        builder: (context, earningsProvider, profileProvider, child) {
          if (earningsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (earningsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppTheme.accentRed, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    earningsProvider.errorMessage!,
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.accentRed),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadEarnings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                _buildPeriodSelector(),
                const SizedBox(height: 16),

                // Summary Cards
                _buildSummaryCards(earningsProvider),
                const SizedBox(height: 16),

                // Weekly Chart (if applicable)
                if (_selectedPeriod == 'week' || _selectedPeriod == 'month' || _selectedPeriod == 'year')
                  _buildWeeklyChart(earningsProvider),
                if (_selectedPeriod == 'week' || _selectedPeriod == 'month' || _selectedPeriod == 'year')
                  const SizedBox(height: 16),

                // Recent Earnings Section
                _buildRecentEarningsSection(earningsProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
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
                
                final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
                
                if (profileProvider.profile.driverId.isNotEmpty) {
                  await earningsProvider.changePeriod(
                    1, // Using driver ID = 1 for testing
                    newValue,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(EarningsProvider earningsProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${earningsProvider.getPeriodDisplayName()} Earnings',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 300) {
                return Column(
                  children: [
                    _buildEarningCard(
                      'Total Earnings',
                      '₹${earningsProvider.totalEarnings.toStringAsFixed(2)}',
                      Icons.currency_rupee,
                      AppTheme.accentGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildEarningCard(
                      'Total Trips',
                      '${earningsProvider.totalTrips}',
                      Icons.directions_car,
                      AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildEarningCard(
                      'Avg per Trip',
                      '₹${earningsProvider.averagePerTrip.toStringAsFixed(2)}',
                      Icons.trending_up,
                      AppTheme.accentOrange,
                    ),
                    const SizedBox(height: 12),
                    _buildEarningCard(
                      'Hours Worked',
                      '${earningsProvider.totalHours.toStringAsFixed(1)}',
                      Icons.access_time,
                      Colors.purple,
                    ),
                  ],
                );
              } else if (constraints.maxWidth < 500) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildEarningCard(
                            'Total Earnings',
                            '₹${earningsProvider.totalEarnings.toStringAsFixed(2)}',
                            Icons.currency_rupee,
                            AppTheme.accentGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildEarningCard(
                            'Total Trips',
                            '${earningsProvider.totalTrips}',
                            Icons.directions_car,
                            AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEarningCard(
                            'Avg per Trip',
                            '₹${earningsProvider.averagePerTrip.toStringAsFixed(2)}',
                            Icons.trending_up,
                            AppTheme.accentOrange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildEarningCard(
                            'Hours Worked',
                            '${earningsProvider.totalHours.toStringAsFixed(1)}',
                            Icons.access_time,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _buildEarningCard(
                        'Total Earnings',
                        '₹${earningsProvider.totalEarnings.toStringAsFixed(2)}',
                        Icons.currency_rupee,
                        AppTheme.accentGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildEarningCard(
                        'Total Trips',
                        '${earningsProvider.totalTrips}',
                        Icons.directions_car,
                        AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildEarningCard(
                        'Avg per Trip',
                        '₹${earningsProvider.averagePerTrip.toStringAsFixed(2)}',
                        Icons.trending_up,
                        AppTheme.accentOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildEarningCard(
                        'Hours Worked',
                        '${earningsProvider.totalHours.toStringAsFixed(1)}',
                        Icons.access_time,
                        Colors.purple,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEarningCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
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

  Widget _buildWeeklyChart(EarningsProvider earningsProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Earnings',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          if (earningsProvider.weeklyData.isEmpty)
            Center(
              child: Text(
                'No weekly data available',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGrey),
              ),
            )
          else
            _buildChart(earningsProvider),
        ],
      ),
    );
  }

  Widget _buildChart(EarningsProvider earningsProvider) {
    final maxAmount = earningsProvider.weeklyData.isNotEmpty
        ? earningsProvider.weeklyData.map((e) => e['amount'] as double).reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double barWidth;
              double chartHeight;

              if (constraints.maxWidth < 300) {
                barWidth = 15.0;
                chartHeight = 80.0;
              } else if (constraints.maxWidth < 500) {
                barWidth = 20.0;
                chartHeight = 90.0;
              } else {
                barWidth = 30.0;
                chartHeight = 100.0;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: earningsProvider.weeklyData.map((dayData) {
                  final amount = dayData['amount'] as double;
                  final height = maxAmount > 0 ? (amount / maxAmount) * chartHeight : 0.0;
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: barWidth,
                        height: height,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dayData['day_short'] as String,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.neutralGreyLight,
                          fontSize: constraints.maxWidth < 300 ? 10 : 12,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 300) {
              return Column(
                children: [
                  Text(
                    '₹${earningsProvider.weeklyTotal.toStringAsFixed(2)}',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  Text(
                    'Total This Week',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutralGreyLight,
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '₹${earningsProvider.weeklyTotal.toStringAsFixed(2)}',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  Text(
                    'Total This Week',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutralGreyLight,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildRecentEarningsSection(EarningsProvider earningsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Earnings',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 12),
        if (earningsProvider.recentEarnings.isEmpty)
          AppCard(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long, color: AppTheme.neutralGreyLight, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No recent earnings found',
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGrey),
                  ),
                ],
              ),
            ),
          )
        else
          ...earningsProvider.recentEarnings.map((earning) => _buildEarningItemCard(earning)).toList(),
      ],
    );
  }

  Widget _buildEarningItemCard(Earning earning) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.directions_car,
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
                  'Trip #${earning.tripId}',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(earning.createdAt),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutralGreyLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${earning.amount.toStringAsFixed(2)}',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}