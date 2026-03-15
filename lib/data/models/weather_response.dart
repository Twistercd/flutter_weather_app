import 'package:json_annotation/json_annotation.dart';
import 'weather_city.dart';
import 'weather_item.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final WeatherCity city;
  final List<WeatherItem> list;

  WeatherResponse({
    required this.city,
    required this.list,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);
}