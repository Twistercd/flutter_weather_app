import 'package:flutter/material.dart';
import '/data/weather_repository.dart';
import '/data/models/weather_display_model.dart';

class WeatherState extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherState(this.repository);

  String? errorMessage;
  bool isLoading = false;
  WeatherDisplayModel? weatherData;

  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await repository.fetchWeather(city);
      weatherData = WeatherDisplayModel.fromResponse(data);
    } catch (e) {
      weatherData = null;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  IconData getWeatherIcon(String? type) {
    switch (type) {
      case 'Clear': return Icons.wb_sunny;
      case 'Clouds': return Icons.cloud;
      case 'Rain': return Icons.umbrella;
      case 'Drizzle': return Icons.grain;
      case 'Thunderstorm': return Icons.flash_on;
      case 'Snow': return Icons.ac_unit;
      default: return Icons.wb_cloudy;
    }
  }
}