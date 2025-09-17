import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/api_service.dart';
import '../models/accident.dart';
import 'accident_detail_screen.dart';

class AccidentListPage extends StatefulWidget {
  @override
  _AccidentListPageState createState() => _AccidentListPageState();
}

class _AccidentListPageState extends State<AccidentListPage> {
  List<Accident> accidents = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    // You can also run a timer to check every X seconds
  }

  void fetchData() async {
    try {
      var newAccidents = await ApiService.fetchAccidents();
      setState(() {
        accidents = newAccidents;
      });

      // Show notification if new report found
      if (accidents.isNotEmpty) {
        showNotification(accidents.first);
      }
    } catch (e) {
      print(e);
    }
  }

  void showNotification(Accident accident) async {
    var androidDetails = const AndroidNotificationDetails(
      'accident_channel',
      'Accidents',
      importance: Importance.max,
      priority: Priority.high,
    );
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "New Accident Report",
      "At ${accident.location}",
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pending Accidents")),
      body: ListView.builder(
        itemCount: accidents.length,
        itemBuilder: (context, index) {
          var acc = accidents[index];
          return ListTile(
            title: Text(acc.location),
            subtitle: Text(acc.description),
            trailing: ElevatedButton(
              child: const Text("View"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccidentDetailPage(accident: acc),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
