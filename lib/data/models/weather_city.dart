import 'package:json_annotation/json_annotation.dart';

part 'weather_city.g.dart';

@JsonSerializable()
class WeatherCity {
  final String name;

  WeatherCity({
    required this.name,
  });

  factory WeatherCity.fromJson(Map<String, dynamic> json) => 
      _$WeatherCityFromJson(json);
}