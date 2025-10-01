import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/trip_history_screen.dart';
import 'screens/earnings_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/help_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/accident_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/earnings_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'widgets/notification_banner.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize notification service with error handling
    try {
      await NotificationService.initialize();
      print('✅ NotificationService initialized successfully');
    } catch (e) {
      print('⚠️ Warning: Notification initialization failed: $e');
      // Continue app startup even if notifications fail
    }

    runApp(const AmbulanceDriverApp());
  } catch (e) {
    print('❌ Critical error during app initialization: $e');
    // Show error screen or fallback
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('App failed to initialize', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Error: $e', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    ));
  }
}

class AmbulanceDriverApp extends StatelessWidget {
  const AmbulanceDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => EmergencyProvider()),
        ChangeNotifierProvider(create: (context) => AccidentProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => EarningsProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Driver App',
        theme: AppTheme.lightTheme,
        home: const NotificationBannerOverlay(
          child: AuthWrapper(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const TripHistoryScreen(),
    const EarningsScreen(),
    const WalletScreen(),
    const HelpScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load profile after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
          profileProvider.loadProfile();
        } catch (e) {
          print('Error loading profile: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: _screens[navigationProvider.currentIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.white.withOpacity(0.1),
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationProvider.currentIndex,
              onTap: navigationProvider.navigateToScreen,
              backgroundColor: const Color(0xFF424242),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[400],
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.square),
                  label: 'Trips',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.currency_rupee),
                  label: 'Earnings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline),
                  label: 'Help',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initializeAuth();
    } catch (e) {
      print('Error initializing auth: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}