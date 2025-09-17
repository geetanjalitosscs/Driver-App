import 'package:mysql1/mysql1.dart';
import '../config/database_config.dart';

class DatabaseHelper {
  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      user: DatabaseConfig.user,
      password: DatabaseConfig.password,
      db: DatabaseConfig.database,
    );

    return await MySqlConnection.connect(settings);
  }

  /// Test database connection
  static Future<bool> testConnection() async {
    try {
      final conn = await connect();
      await conn.close();
      return true;
    } catch (e) {
      print('Database connection failed: $e');
      return false;
    }
  }

  /// Close database connection
  static Future<void> closeConnection(MySqlConnection conn) async {
    try {
      await conn.close();
    } catch (e) {
      print('Error closing database connection: $e');
    }
  }
}
