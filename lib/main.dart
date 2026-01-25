import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'local.dart';
import 'data/weather_repository.dart';
import 'state/weather_state.dart';
import 'weather_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherState(
        WeatherRepository(openWeatherApiKey)
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Weather App', home: const WeatherPage());
  }
}
