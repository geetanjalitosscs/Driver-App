import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          padding: const EdgeInsets.all(16),
        ),
        title: Text(
          'Earnings',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Earnings Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Earnings",
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: 16),
                   LayoutBuilder(
                     builder: (context, constraints) {
                       if (constraints.maxWidth < 300) {
                         // Stack vertically for very small screens
                         return Column(
                           children: [
                             Center(
                               child: SizedBox(
                                 width: constraints.maxWidth * 0.8, // Use 80% of screen width
                                 child: _buildEarningCard(
                                   'Total Earnings',
                                   '₹1,850',
                                   Icons.currency_rupee,
                                   AppTheme.accentGreen,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 12),
                             Center(
                               child: SizedBox(
                                 width: constraints.maxWidth * 0.8,
                                 child: _buildEarningCard(
                                   'Trips Today',
                                   '12',
                                   Icons.directions_car,
                                   AppTheme.primaryBlue,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 12),
                             Center(
                               child: SizedBox(
                                 width: constraints.maxWidth * 0.8,
                                 child: _buildEarningCard(
                                   'Avg per Trip',
                                   '₹154',
                                   Icons.trending_up,
                                   AppTheme.accentOrange,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 12),
                             Center(
                               child: SizedBox(
                                 width: constraints.maxWidth * 0.8,
                                 child: _buildEarningCard(
                                   'Hours Worked',
                                   '8.5',
                                   Icons.access_time,
                                   Colors.purple,
                                 ),
                               ),
                             ),
                           ],
                         );
                       } else if (constraints.maxWidth < 500) {
                         // Use 2x2 grid for medium screens
                         return Column(
                           children: [
                             Row(
                               children: [
                                 Expanded(
                                   child: _buildEarningCard(
                                     'Total Earnings',
                                     '₹1,850',
                                     Icons.currency_rupee,
                                     AppTheme.accentGreen,
                                   ),
                                 ),
                                 const SizedBox(width: 12),
                                 Expanded(
                                   child: _buildEarningCard(
                                     'Trips Today',
                                     '12',
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
                                     '₹154',
                                     Icons.trending_up,
                                     AppTheme.accentOrange,
                                   ),
                                 ),
                                 const SizedBox(width: 12),
                                 Expanded(
                                   child: _buildEarningCard(
                                     'Hours Worked',
                                     '8.5',
                                     Icons.access_time,
                                     Colors.purple,
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         );
                       } else {
                         // Use 4x1 row for wide screens
                         return Row(
                           children: [
                             Expanded(
                               child: _buildEarningCard(
                                 'Total Earnings',
                                 '₹1,850',
                                 Icons.currency_rupee,
                                 AppTheme.accentGreen,
                               ),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                               child: _buildEarningCard(
                                 'Trips Today',
                                 '12',
                                 Icons.directions_car,
                                 AppTheme.primaryBlue,
                               ),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                               child: _buildEarningCard(
                                 'Avg per Trip',
                                 '₹154',
                                 Icons.trending_up,
                                 AppTheme.accentOrange,
                               ),
                             ),
                             const SizedBox(width: 12),
                             Expanded(
                               child: _buildEarningCard(
                                 'Hours Worked',
                                 '8.5',
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
            ),
            const SizedBox(height: 16),
            
            // Weekly Earnings
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Earnings',
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildWeeklyChart(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Recent Transactions
            Text(
              'Recent Transactions',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: 12),
            
            // Transaction List
            ...List.generate(5, (index) => _buildTransactionCard(index)),
          ],
        ),
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

  Widget _buildWeeklyChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final earnings = [1200, 1500, 1800, 1600, 1900, 2200, 1850];
    
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
                 children: List.generate(days.length, (index) {
                   final height = (earnings[index] / 2500) * chartHeight;
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
                         days[index],
                         style: AppTheme.bodySmall.copyWith(
                           color: AppTheme.neutralGreyLight,
                           fontSize: constraints.maxWidth < 300 ? 10 : 12,
                         ),
                       ),
                     ],
                   );
                 }),
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
                    '₹${earnings.reduce((a, b) => a + b)}',
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
                    '₹${earnings.reduce((a, b) => a + b)}',
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

  Widget _buildTransactionCard(int index) {
    final transactions = [
      {'patient': 'John Doe', 'amount': '₹180', 'time': '2:30 PM', 'type': 'Trip'},
      {'patient': 'Jane Smith', 'amount': '₹220', 'time': '1:15 PM', 'type': 'Trip'},
      {'patient': 'Mike Johnson', 'amount': '₹160', 'time': '11:45 AM', 'type': 'Trip'},
      {'patient': 'Bonus', 'amount': '₹100', 'time': '10:00 AM', 'type': 'Bonus'},
      {'patient': 'Sarah Wilson', 'amount': '₹200', 'time': '9:20 AM', 'type': 'Trip'},
    ];
    
    final transaction = transactions[index];
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction['type'] == 'Bonus' 
                  ? AppTheme.accentOrange.withOpacity(0.1)
                  : AppTheme.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              transaction['type'] == 'Bonus' ? Icons.card_giftcard : Icons.directions_car,
              color: transaction['type'] == 'Bonus' ? AppTheme.accentOrange : AppTheme.accentGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['patient']!,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['time']!,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutralGreyLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction['amount']!,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}
