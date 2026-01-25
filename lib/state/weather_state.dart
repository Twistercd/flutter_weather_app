import 'package:flutter/material.dart';
import '/data/weather_repository.dart';


class WeatherState extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherState(this.repository);

  String result = "";
  List<String> threeDayForecast = [];
  bool isLoading = false;

  String parseCurrentWeather(Map<String, dynamic> data) {
    final temp = data['list'][0]['main']['temp'].round();
    final description = data['list'][0]['weather'][0]['description'];

    return "Now: $temp°C, $description";
  }

  List<String> parseThreeDayForecast(Map<String, dynamic> data) {
    final List list = data['list'] ?? [];
    final List<String> forecast = [];

    for (int i = 0; i < list.length && forecast.length < 3; i += 8) {
      final day = list[i];
      if (day == null) continue;

      final temp = (day['main']?['temp'] ?? 0).round();
      final desc = day['weather'] != null && day['weather'].isNotEmpty
          ? day['weather'][0]['description']
          : "N/A";

      forecast.add("Day ${forecast.length + 1}: $temp°C, $desc");
    }

    return forecast;
  }

  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final data = await repository.fetchWeather(city);
      result = parseCurrentWeather(data);
      threeDayForecast = parseThreeDayForecast(data);
    } catch (e) {
      result = "Error loading weather";
      threeDayForecast = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
