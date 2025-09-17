import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/accident.dart';

class ApiService {
  static const String baseUrl = "http://your-domain.com"; // change

  static Future<List<Accident>> fetchAccidents() async {
    final response = await http.get(Uri.parse("$baseUrl/get_accidents.php"));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Accident.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load accidents");
    }
  }

  static Future<bool> updateAccidentStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_accident.php"),
      body: {"id": id.toString(), "status": status},
    );
    return response.statusCode == 200;
  }
}
