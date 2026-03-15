// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) =>
    WeatherCondition(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherConditionToJson(WeatherCondition instance) =>
    <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };
