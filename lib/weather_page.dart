import 'package:flutter/material.dart';
import 'state/weather_state.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatelessWidget {
  WeatherPage({super.key});

  final TextEditingController _cityController = TextEditingController();

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
            _WeatherContent(),
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
            decoration: const InputDecoration(hintText: "Enter city", border: OutlineInputBorder()),
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

        if (state.currentTemp != null && state.currentDescription != null) {
          return Column(
            children: [
              _CurrentWeatherCard(
                temperature: state.currentTemp!,
                description: state.currentDescription!,
                weatherType: state.currentWeatherType,
              ),
              const SizedBox(height: 16),
              _ForecastList(forecast: state.threeDayForecast),
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

  IconData getWeatherIcon(String? type) {
    switch (type) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.umbrella;
      case 'Snow':
        return Icons.ac_unit;
      case 'Thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = getWeatherIcon(weatherType);

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
  final List<String> forecast;

  const _ForecastList({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: forecast.map((day) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(padding: const EdgeInsets.all(12), child: Text(day)),
        );
      }).toList(),
    );
  }
}
