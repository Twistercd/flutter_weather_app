// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherMain _$WeatherMainFromJson(Map<String, dynamic> json) => WeatherMain(
  temp: (json['temp'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
);

Map<String, dynamic> _$WeatherMainToJson(WeatherMain instance) =>
    <String, dynamic>{'temp': instance.temp, 'humidity': instance.humidity};
