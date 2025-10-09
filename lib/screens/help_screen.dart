import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../providers/navigation_provider.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // FAQ Categories data with detailed content
  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Account Issues', 
      'icon': Icons.person, 
      'color': Colors.blue, 
      'keywords': 'account profile login signup',
      'content': {
        'common_issues': [
          'How to update my profile information?',
          'What if I forgot my password?',
          'How to change my phone number?',
          'Account verification problems',
          'Profile photo upload issues'
        ],
        'solutions': [
          'Go to Profile → Edit Profile → Update information',
          'Use "Forgot Password" on login screen',
          'Contact support for phone number changes',
          'Check email for verification link',
          'Use clear, well-lit photos under 5MB'
        ],
        'contact_info': 'For account issues, contact support at +18005709696'
      }
    },
    {
      'title': 'Trip Problems', 
      'icon': Icons.work, 
      'color': Colors.orange, 
      'keywords': 'trip ride journey travel',
      'content': {
        'common_issues': [
          'Trip not starting properly',
          'Navigation not working',
          'Location tracking issues',
          'Trip completion problems',
          'Route optimization issues'
        ],
        'solutions': [
          'Ensure GPS is enabled and location permissions granted',
          'Check internet connection and restart app',
          'Allow location access in device settings',
          'Complete trip within valid area',
          'Use recommended routes for better efficiency'
        ],
        'contact_info': 'Trip support available 24/7 at 18005709696'
      }
    },
    {
      'title': 'Payment Issues', 
      'icon': Icons.schedule, 
      'color': Colors.purple, 
      'keywords': 'payment money wallet cash',
      'content': {
        'common_issues': [
          'Payment not received',
          'Wallet balance incorrect',
          'Withdrawal pending',
          'Payment method issues',
          'Transaction history problems'
        ],
        'solutions': [
          'Check bank account for pending transfers',
          'Refresh wallet and check transaction history',
          'Withdrawals process within 2-3 business days',
          'Update payment method in wallet settings',
          'Contact support for transaction disputes'
        ],
        'contact_info': 'Payment support: apatkalindia@gmail.com'
      }
    },
    {
      'title': 'Trip History', 
      'icon': Icons.description, 
      'color': Colors.teal, 
      'keywords': 'history past trips record',
      'content': {
        'common_issues': [
          'Missing trip records',
          'Incorrect trip details',
          'History not loading',
          'Trip status issues',
          'Earnings calculation problems'
        ],
        'solutions': [
          'Refresh trip history and check internet connection',
          'Verify trip details with support team',
          'Clear app cache and restart',
          'Check trip completion status',
          'Review earnings breakdown in earnings section'
        ],
        'contact_info': 'Trip history support available via WhatsApp'
      }
    },
    {
      'title': 'Earnings & Payouts', 
      'icon': Icons.currency_rupee, 
      'color': Colors.green, 
      'keywords': 'earnings money payout income',
      'content': {
        'common_issues': [
          'Earnings not showing',
          'Payout delays',
          'Incorrect earnings calculation',
          'Tax document issues',
          'Bonus payment problems'
        ],
        'solutions': [
          'Check earnings section for latest updates',
          'Payouts process within 2-3 business days',
          'Review trip completion and fare calculation',
          'Download tax documents from earnings section',
          'Check bonus eligibility in app notifications'
        ],
        'contact_info': 'Earnings support: 18005709696'
      }
    },
    {
      'title': 'Technical Support', 
      'icon': Icons.computer, 
      'color': Colors.red, 
      'keywords': 'technical support help bug error',
      'content': {
        'common_issues': [
          'App crashes or freezes',
          'Login problems',
          'Notification issues',
          'GPS accuracy problems',
          'App performance issues'
        ],
        'solutions': [
          'Update app to latest version',
          'Clear app data and re-login',
          'Check notification permissions',
          'Calibrate GPS and check signal strength',
          'Restart device and clear cache'
        ],
        'contact_info': 'Technical support: apatkalindia@gmail.com'
      }
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter FAQ categories based on search query
  List<Map<String, dynamic>> _getFilteredCategories() {
    if (_searchQuery.isEmpty) {
      return _faqCategories;
    }
    
    return _faqCategories.where((category) {
      final title = category['title'].toString().toLowerCase();
      final keywords = category['keywords'].toString().toLowerCase();
      return title.contains(_searchQuery) || keywords.contains(_searchQuery);
    }).toList();
  }

  // Contact methods
  Future<void> _openWhatsApp() async {
    const phoneNumber = '+18005709696'; // Remove spaces and add country code
    final url = 'https://wa.me/$phoneNumber';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open WhatsApp');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to open WhatsApp: $e');
    }
  }

  Future<void> _makePhoneCall() async {
    const phoneNumber = '+18005709696';
    final url = 'tel:$phoneNumber';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not make phone call');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to make phone call: $e');
    }
  }

  Future<void> _sendEmail() async {
    const email = 'apatkalindia@gmail.com';
    final url = 'mailto:$email?subject=Driver App Support';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open email client');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to open email: $e');
    }
  }

  Future<void> _openMessageApp() async {
    const phoneNumber = '+18005709696';
    final url = 'sms:$phoneNumber';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open messaging app');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to open messaging: $e');
    }
  }

  Future<void> _callEmergencySupport() async {
    const phoneNumber = '18005709696';
    final url = 'tel:$phoneNumber';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not make emergency call');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to make emergency call: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Custom WhatsApp Icon Widget with speech bubble and tail
  Widget _buildWhatsAppIcon({double size = 24, Color color = Colors.white}) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Speech bubble with tail
          CustomPaint(
            size: Size(size, size),
            painter: _SpeechBubblePainter(color: color),
          ),
          // Phone icon inside the speech bubble
          Positioned(
            left: size * 0.15,
            top: size * 0.15,
            child: Icon(
              Icons.phone,
              color: const Color(0xFF25D366),
              size: size * 0.35,
            ),
          ),
        ],
      ),
    );
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          padding: const EdgeInsets.all(16),
        ),
        title: Text(
          'Help Center',
          style: AppTheme.heading3.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),
            
            // FAQ Categories
            _buildFAQSection(),
            const SizedBox(height: 24),
            
            // Contact Support
            _buildContactSupportSection(),
            const SizedBox(height: 24),
            
            // Emergency Support Line
            _buildEmergencySupportLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for help...',
          hintStyle: GoogleFonts.roboto(
            fontSize: 16,
            color: AppTheme.textLight.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.textLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppTheme.textMedium,
                        size: 16,
                      ),
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryBlue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: GoogleFonts.roboto(
          fontSize: 16,
          color: AppTheme.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'FAQ Categories',
              style: AppTheme.heading3,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_getFilteredCategories().length} result${_getFilteredCategories().length != 1 ? 's' : ''}',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _getFilteredCategories().isEmpty && _searchQuery.isNotEmpty
            ? _buildNoResultsFound()
            :         LayoutBuilder(
          builder: (context, constraints) {
            final categories = _getFilteredCategories();
            
            if (constraints.maxWidth < 300) {
              // Stack vertically for very small screens
              return Column(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: SizedBox(
                        width: constraints.maxWidth * 0.8, // Use 80% of screen width
                        child: _buildFAQCategory(
                          category['title'],
                          category['icon'],
                          category['color'],
                          _getFilteredCategories().indexOf(category),
                          isVertical: true,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else if (constraints.maxWidth < 400) {
              // Use 2x2 grid for small screens
              return Column(
                children: _buildFAQRows(categories, 2, isSmall: true),
              );
            } else if (constraints.maxWidth < 600) {
              // Use 2x3 grid for medium screens
              return Column(
                children: _buildFAQRows(categories, 2, isMedium: true),
              );
            } else {
              // Use 3x2 grid for larger screens
              return Column(
                children: _buildFAQRows(categories, 3, isLarge: true),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNoResultsFound() {
    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.neutralGreyLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFAQRows(List<Map<String, dynamic>> categories, int itemsPerRow, {bool isSmall = false, bool isMedium = false, bool isLarge = false}) {
    List<Widget> rows = [];
    
    for (int i = 0; i < categories.length; i += itemsPerRow) {
      List<Widget> rowItems = [];
      
      for (int j = i; j < i + itemsPerRow && j < categories.length; j++) {
        final category = categories[j];
        rowItems.add(
          Expanded(
            child: _buildFAQCategory(
              category['title'],
              category['icon'],
              category['color'],
              _getFilteredCategories().indexOf(category),
              isSmall: isSmall,
              isMedium: isMedium,
              isLarge: isLarge,
            ),
          ),
        );
        
        if (j < i + itemsPerRow - 1 && j < categories.length - 1) {
          rowItems.add(const SizedBox(width: 12));
        }
      }
      
      rows.add(Row(children: rowItems));
      
      if (i + itemsPerRow < categories.length) {
        rows.add(const SizedBox(height: 12));
      }
    }
    
    return rows;
  }

  Widget _buildFAQCategory(String title, IconData icon, Color color, int index, {bool isVertical = false, bool isSmall = false, bool isMedium = false, bool isLarge = false}) {
    // Determine sizes based on screen type
    double iconSize;
    double iconPadding;
    double cardPadding;
    double spacing;
    TextStyle textStyle;
    
    if (isVertical) {
      // Vertical layout for very small screens
      iconSize = 32;
      iconPadding = 12;
      cardPadding = 16;
      spacing = 12;
      textStyle = AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600);
    } else if (isSmall) {
      // Small screens
      iconSize = 28;
      iconPadding = 10;
      cardPadding = 14;
      spacing = 10;
      textStyle = AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600);
    } else if (isMedium) {
      // Medium screens
      iconSize = 32;
      iconPadding = 12;
      cardPadding = 16;
      spacing = 12;
      textStyle = AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600);
    } else if (isLarge) {
      // Large screens
      iconSize = 36;
      iconPadding = 14;
      cardPadding = 18;
      spacing = 14;
      textStyle = AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600);
    } else {
      // Default
      iconSize = 24;
      iconPadding = 8;
      cardPadding = 12;
      spacing = 8;
      textStyle = AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600);
    }
    
    return GestureDetector(
      onTap: () {
        _showFAQPopup(index);
      },
      child: AppCard(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: iconSize,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              title,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showFAQPopup(int index) {
    final category = _getFilteredCategories()[index];
    final content = category['content'] as Map<String, dynamic>;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        category['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category['title'],
                        style: AppTheme.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Common Issues Section
                      Text(
                        'Common Issues:',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(content['common_issues'] as List<String>).map((issue) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  issue,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.neutralGreyLight,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                      
                      const SizedBox(height: 24),
                      
                      // Solutions Section
                      Text(
                        'Solutions:',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(content['solutions'] as List<String>).map((solution) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  solution,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.neutralGreyLight,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                      
                      const SizedBox(height: 24),
                      
                      // Contact Info Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.contact_support,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                content['contact_info'] as String,
                                style: AppTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Footer with Close Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildContactSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 350) {
              // Stack vertically for very small screens
              return Column(
                children: [
                  _buildWhatsAppButton('WhatsApp Us', _openWhatsApp),
                  const SizedBox(height: 12),
                  _buildMessageButton('Message Us', _openMessageApp),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Call Us',
                    icon: Icons.phone,
                    variant: AppButtonVariant.outline,
                    isFullWidth: true,
                    onPressed: _makePhoneCall,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Email Us',
                    icon: Icons.email,
                    variant: AppButtonVariant.outline,
                    isFullWidth: true,
                    onPressed: _sendEmail,
                  ),
                ],
              );
            } else if (constraints.maxWidth < 500) {
              // Use 2x2 grid for medium screens
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildWhatsAppButton('WhatsApp Us', _openWhatsApp)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMessageButton('Message Us', _openMessageApp)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Call Us',
                          icon: Icons.phone,
                          variant: AppButtonVariant.outline,
                          onPressed: _makePhoneCall,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'Email Us',
                          icon: Icons.email,
                          variant: AppButtonVariant.outline,
                          onPressed: _sendEmail,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Use horizontal layout for larger screens
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildWhatsAppButton('WhatsApp Us', _openWhatsApp)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMessageButton('Message Us', _openMessageApp)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Call Us',
                          icon: Icons.phone,
                          variant: AppButtonVariant.outline,
                          onPressed: _makePhoneCall,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'Email Us',
                          icon: Icons.email,
                          variant: AppButtonVariant.outline,
                          onPressed: _sendEmail,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildWhatsAppButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.whatsappGreen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.whatsappGreen.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWhatsAppIcon(size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_in_talk, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySupportLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        String buttonText;
        if (constraints.maxWidth < 300) {
          buttonText = 'Emergency: 18005709696';
        } else {
          buttonText = 'Emergency Support Line: 18005709696';
        }
        
        return AppButton(
          text: buttonText,
          icon: Icons.emergency,
          variant: AppButtonVariant.danger,
          size: AppButtonSize.large,
          isFullWidth: true,
          onPressed: _callEmergencySupport,
        );
      },
    );
  }
}

// Custom painter for WhatsApp speech bubble with tail
class _SpeechBubblePainter extends CustomPainter {
  final Color color;

  _SpeechBubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Main speech bubble (rounded rectangle)
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * 0.75, size.height * 0.75),
      const Radius.circular(4),
    );
    path.addRRect(bubbleRect);
    
    // Speech bubble tail (pointing down-right)
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.6, size.height * 0.75); // Start of tail
    tailPath.lineTo(size.width * 0.9, size.height * 0.6); // Bottom-right point
    tailPath.lineTo(size.width * 0.75, size.height * 0.9); // Bottom point
    tailPath.close();
    
    path.addPath(tailPath, Offset.zero);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom WhatsApp Icon Widget
class WhatsAppIcon extends StatelessWidget {
  final double size;
  
  const WhatsAppIcon({super.key, this.size = 24.0});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: WhatsAppIconPainter(),
    );
  }
}

class WhatsAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Outer white circle
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
    
    // Inner green circle
    paint.color = const Color(0xFF25D366); // WhatsApp green
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 2,
      paint,
    );
    
    // White phone icon
    paint.color = Colors.white;
    final phonePath = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final phoneSize = size.width * 0.4;
    
    // Phone receiver shape
    phonePath.moveTo(centerX - phoneSize * 0.3, centerY - phoneSize * 0.2);
    phonePath.lineTo(centerX + phoneSize * 0.3, centerY - phoneSize * 0.2);
    phonePath.lineTo(centerX + phoneSize * 0.3, centerY + phoneSize * 0.2);
    phonePath.lineTo(centerX - phoneSize * 0.3, centerY + phoneSize * 0.2);
    phonePath.close();
    
    // Phone handle
    phonePath.moveTo(centerX - phoneSize * 0.15, centerY + phoneSize * 0.2);
    phonePath.lineTo(centerX - phoneSize * 0.15, centerY + phoneSize * 0.4);
    phonePath.lineTo(centerX + phoneSize * 0.15, centerY + phoneSize * 0.4);
    phonePath.lineTo(centerX + phoneSize * 0.15, centerY + phoneSize * 0.2);
    phonePath.close();
    
    canvas.drawPath(phonePath, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


