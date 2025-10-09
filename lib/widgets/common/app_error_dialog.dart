import 'package:flutter/material.dart';

class AppErrorDialog {
  static Future<void> show(BuildContext context, String message, {String title = 'Error'}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.red.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}


