import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherRepository {
  final String apiKey;

  WeatherRepository(this.apiKey);

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast"
      "?q=$city&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Weather API error");
    }

    return jsonDecode(response.body);
  }
}
