import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/accident_report.dart';

class AccidentDetailPage extends StatelessWidget {
  final AccidentReport accident;
  const AccidentDetailPage({required this.accident});

  void updateStatus(BuildContext context, String status) async {
    bool success = await CentralizedApiService.updateAccidentStatus(accident.id, status);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated: $status")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accident Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${accident.fullname}"),
            Text("Phone: ${accident.phone}"),
            Text("Vehicle: ${accident.vehicle}"),
            Text("Location: ${accident.location}"),
            Text("Description: ${accident.description}"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => updateStatus(context, "accepted"),
                  child: const Text("Accept"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateStatus(context, "declined"),
                  child: const Text("Decline"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
