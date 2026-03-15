// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherItem _$WeatherItemFromJson(Map<String, dynamic> json) => WeatherItem(
  dt: (json['dt'] as num).toInt(),
  main: WeatherMain.fromJson(json['main'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  dtTxt: json['dt_txt'] as String,
);

Map<String, dynamic> _$WeatherItemToJson(WeatherItem instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'dt_txt': instance.dtTxt,
    };
