/// Database Configuration
/// 
/// Update these values with your actual MySQL database credentials
class DatabaseConfig {
  // Database connection settings
  static const String host = '127.0.0.1';           // e.g., '127.0.0.1' or 'localhost'
  static const int port = 3306;                    // Alternative MySQL port
  static const String user = 'root';          // XAMPP default user
  static const String password = '';  // XAMPP default (no password)
  static const String database = 'edueyeco_apatkal';        // Driver app database name
  
  // API Base URL for trip operations
  static const String baseUrl = 'http://localhost/Driver-App';
  
  /// Get connection settings as a map
  static Map<String, dynamic> get connectionSettings => {
    'host': host,
    'port': port,
    'user': user,
    'password': password,
    'database': database,
  };
  
  /// Test if configuration is properly set
  static bool get isConfigured => 
      host != 'localhost' && 
      user != 'root' && 
      password != '';
}

/// Example configuration for local development:
/// 
/// static const String host = '127.0.0.1';
/// static const String user = 'root';
/// static const String password = 'your_password';
/// 
/// Example configuration for remote server:
/// 
/// static const String host = 'your-server.com';
/// static const String user = 'your_username';
/// static const String password = 'your_password';
