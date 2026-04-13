import '../data/models/weather_display_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherDisplayModel data;
  WeatherLoaded(this.data);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}