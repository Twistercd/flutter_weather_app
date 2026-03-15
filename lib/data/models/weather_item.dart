import 'package:json_annotation/json_annotation.dart';
import 'weather_main.dart';
import 'weather_condition.dart';

part 'weather_item.g.dart';

@JsonSerializable()
class WeatherItem {
  final int dt;
  final WeatherMain main;
  final List<WeatherCondition> weather;
  @JsonKey(name: 'dt_txt')
  final String dtTxt;

  WeatherItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.dtTxt,
  });

  factory WeatherItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemFromJson(json);
}