import 'package:json_annotation/json_annotation.dart';

part 'weather_main.g.dart';

@JsonSerializable()
class WeatherMain {
  final double temp;
  final int humidity;

  WeatherMain({
    required this.temp,
    required this.humidity,
  });

  factory WeatherMain.fromJson(Map<String, dynamic> json) => 
      _$WeatherMainFromJson(json);
}