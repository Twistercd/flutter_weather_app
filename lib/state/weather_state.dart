import 'package:flutter/material.dart';
import '/data/weather_repository.dart';
import '../models/weather.dart';

class WeatherState extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherState(this.repository);

  String? currentWeatherType;

  int? currentTemp;
  String? currentDescription;
  List<String> threeDayForecast = [];
  bool isLoading = false;

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
      final Weather weather = await repository.fetchWeather(city);

      final current = weather.fromJson['list'][0];

      currentTemp = (current['main']?['temp'] ?? 0).round();
      currentDescription = current['weather']?[0]?['description'];
      currentWeatherType = current['weather']?[0]?['main'];

      threeDayForecast = parseThreeDayForecast(data);
    } catch (e) {
      currentTemp = null;
      currentDescription = null;
      currentWeatherType = null;
      threeDayForecast = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  IconData getWeatherIcon(String? type) {
    switch (type) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.umbrella;
      case 'Drizzle':
        return Icons.grain;
      case 'Thunderstorm':
        return Icons.flash_on;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}
