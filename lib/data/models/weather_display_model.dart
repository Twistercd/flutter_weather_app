import 'weather_response.dart';
import 'weather_item.dart';

class WeatherDisplayModel {
  final String cityName;
  final int temp;
  final String description;
  final String weatherType;
  final List<WeatherItem> forecast;

  WeatherDisplayModel(
    {
      required this.cityName,
      required this.temp,
      required this.description,
      required this.weatherType,
      required this.forecast,
    }
  );

  factory WeatherDisplayModel.fromResponse(WeatherResponse response) {
    final current = response.list.first;

    final Map<String, WeatherItem> byDate = {};
    for (final item in response.list) {
      final date = item.dtTxt.split(' ')[0];
      byDate.putIfAbsent(date, () => item);
    }

    return WeatherDisplayModel(
      cityName: response.city.name,
      temp: current.main.temp.round(),
      description: current.weather.first.description,
      weatherType: current.weather.first.main,
      forecast: byDate.values.skip(1).take(3).toList(),
    );
  }
}