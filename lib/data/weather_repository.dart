import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherRepository {
  final String apiKey;

  WeatherRepository(this.apiKey);

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast"
      "?q=$city&appid=$apiKey&units=metric"),
    );

    print(jsonDecode(response.body)); // Debugging line to check the API response

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
