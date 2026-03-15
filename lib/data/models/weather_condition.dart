import 'package:json_annotation/json_annotation.dart';

part 'weather_condition.g.dart';

@JsonSerializable()
class WeatherCondition {
  final String main;
  final String description;
  final String icon;

  WeatherCondition({required this.main, required this.description, required this.icon});

  factory WeatherCondition.fromJson(Map<String, dynamic> json) => _$WeatherConditionFromJson(json);
}
