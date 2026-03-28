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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _SearchBar(controller: _cityController),
              const SizedBox(height: 8),
              const Expanded(child: _WeatherContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter city",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              context.read<WeatherState>().fetchWeather(controller.text);
            },
          ),
        ],
      ),
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
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state.weatherData != null) {
          final data = state.weatherData!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CityHeader(cityName: data.cityName),
              _MainWeatherInfo(
                temp: data.temp,
                description: data.description,
                weatherType: data.weatherType,
              ),
              _ForecastRow(forecast: data.forecast),
            ],
          );
        }

        return Center(
          child: Text(
            "Enter a city to see\nthe weather forecast",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}

class _CityHeader extends StatelessWidget {
  final String cityName;
  const _CityHeader({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Text(
      cityName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 36,
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
      ),
    );
  }
}

class _MainWeatherInfo extends StatelessWidget {
  final int temp;
  final String description;
  final String? weatherType;

  const _MainWeatherInfo({
    required this.temp,
    required this.description,
    required this.weatherType,
  });

  @override
  Widget build(BuildContext context) {
    final icon = context.read<WeatherState>().getWeatherIcon(weatherType);

    return Column(
      children: [
        Icon(icon, size: 80, color: Colors.white),
        const SizedBox(height: 16),
        Text(
          "$temp°",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final List<WeatherItem> forecast;

  const _ForecastRow({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: forecast.map((day) {
          final icon = context.read<WeatherState>().getWeatherIcon(
            day.weather.first.main,
          );
          final temp = day.main.temp.round();
          final date = DateTime.fromMillisecondsSinceEpoch(day.dt * 1000);
          final weekday = _weekday(date.weekday);

          return Column(
            children: [
              Text(
                weekday,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                "$temp°",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _weekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}