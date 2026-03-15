import 'package:flutter/material.dart';
import '/data/weather_repository.dart';
import '/data/models/weather_response.dart';
import '/data/models/weather_item.dart';

class WeatherState extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherState(this.repository);

  String? currentWeatherType;
  int? currentTemp;
  String? currentDescription;
  String? cityName;
  String? errorMessage;
  List<WeatherItem> forecast = [];
  bool isLoading = false;

  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final WeatherResponse data = await repository.fetchWeather(city);

      final current = data.list.first;
      currentTemp = current.main.temp.round();
      currentDescription = current.weather.first.description;
      currentWeatherType = current.weather.first.main;
      cityName = data.city.name;

      // берём по одному элементу на каждый день
      final Map<String, WeatherItem> byDate = {};
      for (final item in data.list) {
        final date = item.dtTxt.split(' ')[0];
        byDate.putIfAbsent(date, () => item);
      }
      forecast = byDate.values.take(3).toList();

    } catch (e) {
      currentTemp = null;
      currentDescription = null;
      currentWeatherType = null;
      cityName = null;
      forecast = [];
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