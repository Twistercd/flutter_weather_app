import 'package:flutter/material.dart';
import 'state/weather_state.dart';
import 'data/models/weather_item.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CityInput(controller: _cityController),
            const SizedBox(height: 16),
            const _WeatherContent(),
          ],
        ),
      ),
    );
  }
}

class _CityInput extends StatelessWidget {
  final TextEditingController controller;

  const _CityInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter city",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.read<WeatherState>().fetchWeather(controller.text);
          },
        ),
      ],
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherState>(
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 32),
            child: CircularProgressIndicator(),
          );
        }

        if (state.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              state.errorMessage! ,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.currentTemp != null) {
          return Column(
            children: [
              _CurrentWeatherCard(
                temperature: state.currentTemp! ,
                description: state.currentDescription!,
                weatherType: state.currentWeatherType,
              ),
              const SizedBox(height: 16),
              _ForecastList(forecast: state.forecast),
            ],
          );
        }

        return const Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text(
            "Enter a city to see the weather forecast",
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }
}

class _CurrentWeatherCard extends StatelessWidget {
  final int temperature;
  final String description;
  final String? weatherType;

  const _CurrentWeatherCard({
    required this.temperature,
    required this.description,
    required this.weatherType,
  });

  @override
  Widget build(BuildContext context) {
    final icon = context.read<WeatherState>().getWeatherIcon(weatherType);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$temperature°C",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastList extends StatelessWidget {
  final List<WeatherItem> forecast;

  const _ForecastList({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: forecast.map((day) {
        final temp = day.main.temp.round();
        final desc = day.weather.first.description;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text("$temp°C - $desc"),
          ),
        );
      }).toList(),
    );
  }
}