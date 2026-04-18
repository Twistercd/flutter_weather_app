import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'local.dart';
import 'data/weather_repository.dart';
import 'weather_page.dart';
import 'bloc/weather_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => WeatherBloc(
          WeatherRepository(openWeatherApiKey),
        ),
        child: const WeatherPage(),
      ),
    );
  }
}