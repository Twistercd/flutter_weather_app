import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/weather_response.dart';

class WeatherRepository {
  final String apiKey;

  WeatherRepository(this.apiKey);

  Future<WeatherResponse> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      throw Exception("Enter city name");
    }

    final url = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {'q': city, 'appid': apiKey, 'units': 'metric'},
    );

    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception("Request timed out"),
    );

    if (response.statusCode != 200) {
      throw Exception("Weather API error: ${response.statusCode}");
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherResponse.fromJson(json);
  }
}