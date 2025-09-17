import 'package:mysql1/mysql1.dart';
import '../models/accident_report.dart';
import '../config/database_config.dart';
import 'database_helper.dart';

class AccidentService {
  /// Test database connection and show detailed info
  static Future<void> testDatabaseConnection() async {
    try {
      print('=== DATABASE CONNECTION TEST ===');
      print('Host: ${DatabaseConfig.host}');
      print('Port: ${DatabaseConfig.port}');
      print('User: ${DatabaseConfig.user}');
      print('Database: ${DatabaseConfig.database}');
      print('Password: ${DatabaseConfig.password.isEmpty ? "EMPTY" : "SET"}');
      
      final conn = await DatabaseHelper.connect();
      print('✅ Database connection successful!');
      
      // Test if database exists
      final dbCheck = await conn.query('SELECT DATABASE() as current_db');
      final currentDb = dbCheck.first.fields['current_db'];
      print('Current database: $currentDb');
      
      // Test if accidents table exists
      final tableExists = await conn.query(
        "SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = ? AND table_name = 'accidents'",
        [DatabaseConfig.database]
      );
      final exists = (tableExists.first.fields['count'] as int) > 0;
      print('Accidents table exists: $exists');
      
      if (exists) {
        // Get table structure
        final structure = await conn.query('DESCRIBE accidents');
        print('Table structure:');
        for (var row in structure) {
          print('  ${row.fields['Field']}: ${row.fields['Type']}');
        }
      }
      
      await DatabaseHelper.closeConnection(conn);
      print('=== DATABASE CONNECTION TEST END ===');
    } catch (e) {
      print('=== DATABASE CONNECTION ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('=== DATABASE CONNECTION ERROR END ===');
    }
  }
  /// Fetch all pending accident reports from database
  static Future<List<AccidentReport>> fetchAccidents() async {
    try {
      print('=== FETCHING ACCIDENTS DEBUG ===');
      print('Connecting to database...');
      
      final conn = await DatabaseHelper.connect();
      print('Database connected successfully');
      
      // First, let's check if the table exists and has any records
      final tableCheck = await conn.query('SELECT COUNT(*) as total FROM accidents');
      final totalCount = tableCheck.first.fields['total'] as int;
      print('Total records in accidents table: $totalCount');
      
      // Check all statuses
      final statusCheck = await conn.query('SELECT status, COUNT(*) as count FROM accidents GROUP BY status');
      print('Records by status:');
      for (var row in statusCheck) {
        print('  ${row.fields['status']}: ${row.fields['count']}');
      }
      
      // Now fetch pending records
      final results = await conn.query(
        'SELECT * FROM accidents WHERE status = "pending" ORDER BY id ASC'
      );
      
      print('Pending records found: ${results.length}');
      
      List<AccidentReport> accidents = [];
      for (var row in results) {
        print('Processing record: ${row.fields}');
        print('Field types:');
        row.fields.forEach((key, value) {
          print('  $key: ${value.runtimeType} = $value');
        });
        try {
          accidents.add(AccidentReport.fromMap(row.fields));
          print('✅ Record processed successfully');
        } catch (e) {
          print('❌ Error processing record: $e');
          print('Record data: ${row.fields}');
        }
      }

      await DatabaseHelper.closeConnection(conn);
      print('Returning ${accidents.length} accidents');
      print('=== FETCHING ACCIDENTS DEBUG END ===');
      return accidents;
    } catch (e) {
      print('=== ERROR FETCHING ACCIDENTS ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('=== ERROR FETCHING ACCIDENTS END ===');
      return [];
    }
  }

  /// Handle accident report acceptance or rejection
  static Future<bool> handleReport(int id, bool isAccepted, bool showNext) async {
    try {
      final conn = await DatabaseHelper.connect();

      if (isAccepted) {
        // Update status to accepted
        await conn.query(
          'UPDATE accidents SET status = "accepted" WHERE id = ?', 
          [id]
        );
        print('Accident report $id accepted');
        
        // If showNext = false, cancel all next reports (only for accepted reports)
        if (!showNext) {
          await conn.query(
            'UPDATE accidents SET status = "cancelled" WHERE status = "pending" AND id > ?', 
            [id]
          );
          print('All subsequent reports cancelled');
        }
      } else {
        // Update status to rejected and send notification
        await conn.query(
          'UPDATE accidents SET status = "rejected" WHERE id = ?', 
          [id]
        );
        print('Notification: Ambulance is not coming for report $id!');
        // For rejected reports, always show next report (don't cancel others)
      }

      await DatabaseHelper.closeConnection(conn);
      return true;
    } catch (e) {
      print('Error handling report: $e');
      return false;
    }
  }

  /// Get accident report by ID
  static Future<AccidentReport?> getAccidentById(int id) async {
    try {
      final conn = await DatabaseHelper.connect();
      final results = await conn.query(
        'SELECT * FROM accidents WHERE id = ?', 
        [id]
      );

      if (results.isNotEmpty) {
        final accident = AccidentReport.fromMap(results.first.fields);
        await DatabaseHelper.closeConnection(conn);
        return accident;
      }

      await DatabaseHelper.closeConnection(conn);
      return null;
    } catch (e) {
      print('Error getting accident by ID: $e');
      return null;
    }
  }

  /// Update accident status
  static Future<bool> updateAccidentStatus(int id, String status) async {
    try {
      final conn = await DatabaseHelper.connect();
      await conn.query(
        'UPDATE accidents SET status = ? WHERE id = ?', 
        [status, id]
      );
      await DatabaseHelper.closeConnection(conn);
      return true;
    } catch (e) {
      print('Error updating accident status: $e');
      return false;
    }
  }

  /// Get count of pending accidents
  static Future<int> getPendingAccidentsCount() async {
    try {
      final conn = await DatabaseHelper.connect();
      final results = await conn.query(
        'SELECT COUNT(*) as count FROM accidents WHERE status = "pending"'
      );
      
      final count = results.first.fields['count'] as int;
      await DatabaseHelper.closeConnection(conn);
      return count;
    } catch (e) {
      print('Error getting pending accidents count: $e');
      return 0;
    }
  }
}
