import 'package:flutter/material.dart';
import 'weather_page.dart'; // импорт страницы с погодой

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Weather App', home: const WeatherPage());
  }
}
