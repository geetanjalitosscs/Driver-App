import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../providers/notification_provider.dart';
import '../providers/navigation_provider.dart';
import '../models/notification_item.dart' as notification_model;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';

  final List<String> _filters = [
    'all',
    'accidents',
    'trips',
    'earnings',
    'wallet',
    'withdrawals',
    'system'
  ];

  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.loadNotifications();
      notificationProvider.initializeWithSampleNotifications();
    });
  }

  List<notification_model.NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'all') {
      return Provider.of<NotificationProvider>(context, listen: false).notifications;
    }
    
    // Map filter names to NotificationType enum
    notification_model.NotificationType? filterType;
    switch (_selectedFilter) {
      case 'accidents':
        filterType = notification_model.NotificationType.accident;
        break;
      case 'trips':
        filterType = notification_model.NotificationType.trip;
        break;
      case 'earnings':
        filterType = notification_model.NotificationType.earning;
        break;
      case 'wallet':
        filterType = notification_model.NotificationType.wallet;
        break;
      case 'withdrawals':
        filterType = notification_model.NotificationType.withdrawal;
        break;
      case 'system':
        filterType = notification_model.NotificationType.system;
        break;
    }
    
    if (filterType != null) {
      return Provider.of<NotificationProvider>(context, listen: false).getNotificationsByType(filterType);
    }
    
    return Provider.of<NotificationProvider>(context, listen: false).notifications;
  }

  int get _unreadCount {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    return notificationProvider.unreadCount;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
                 appBar: AppBar(
                   leading: IconButton(
                     icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                     onPressed: () {
                       // Navigate to home screen (index 0)
                       final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                       navigationProvider.navigateToScreen(0);
                     },
                   ),
                   title: Text(
                     'Notifications',
                     style: GoogleFonts.roboto(
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                   ),
                   backgroundColor: AppTheme.primaryBlue,
                   elevation: 0,
                   actions: [
              if (notificationProvider.unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${notificationProvider.unreadCount}',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return FilterChip(
                      label: Text(
                        _getFilterLabel(filter),
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.primaryBlue,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppTheme.primaryBlue,
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                        color: AppTheme.primaryBlue,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
              
              // Notifications List
              Expanded(
                child: notificationProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredNotifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final notification = _filteredNotifications[index];
                              return _buildNotificationCard(notification);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

         Widget _buildNotificationCard(notification_model.NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.accentRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: AppTheme.textMedium,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

         void _handleNotificationTap(notification_model.NotificationItem notification) {
    // Mark as read
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.markAsRead(notification.id);

    // Handle navigation based on action data
    final action = notification.actionData['action'] as String?;
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    switch (action) {
      case 'view_accident':
        // Navigate to home screen (where accidents are shown)
        navigationProvider.navigateToHome();
        break;
      case 'navigate_to_trip':
        // Navigate to home screen and show ongoing trip
        navigationProvider.navigateToHome();
        break;
      case 'view_earnings':
        // Navigate to earnings screen
        navigationProvider.navigateToEarnings();
        break;
      case 'view_wallet':
        // Navigate to wallet screen
        navigationProvider.navigateToWallet();
        break;
      case 'view_trips':
        // Navigate to trip history screen
        navigationProvider.navigateToTrips();
        break;
      case 'view_system':
        // Navigate to help screen for system notifications
        navigationProvider.navigateToHelp();
        break;
      default:
        // Default: navigate to home screen
        navigationProvider.navigateToHome();
        break;
    }
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'all': return 'All';
      case 'accidents': return 'Accidents';
      case 'trips': return 'Trips';
      case 'earnings': return 'Earnings';
      case 'wallet': return 'Wallet';
      case 'withdrawals': return 'Withdrawals';
      case 'system': return 'System';
      default: return filter;
    }
  }

         IconData _getNotificationIcon(notification_model.NotificationType type) {
           switch (type) {
             case notification_model.NotificationType.accident:
               return Icons.warning_amber_rounded;
             case notification_model.NotificationType.trip:
               return Icons.directions_car_rounded;
             case notification_model.NotificationType.earning:
               return Icons.currency_rupee_rounded;
             case notification_model.NotificationType.wallet:
               return Icons.account_balance_wallet_rounded;
             case notification_model.NotificationType.withdrawal:
               return Icons.account_balance_rounded;
             case notification_model.NotificationType.system:
               return Icons.info_rounded;
           }
         }

  Color _getNotificationColor(notification_model.NotificationType type) {
    switch (type) {
      case notification_model.NotificationType.accident:
        return AppTheme.accentRed;
      case notification_model.NotificationType.trip:
        return AppTheme.primaryBlue;
      case notification_model.NotificationType.earning:
        return Colors.green;
      case notification_model.NotificationType.wallet:
        return AppTheme.accentPurple;
      case notification_model.NotificationType.withdrawal:
        return Colors.blue;
      case notification_model.NotificationType.system:
        return Colors.orange;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final Map<String, dynamic> actionData;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.actionData,
  });
}

enum NotificationType {
  accident,
  trip,
  earning,
  system,
}

