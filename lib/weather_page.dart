import 'package:flutter/material.dart';
import 'state/weather_state.dart';
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
      appBar: AppBar(title: const Text("Weather Forecast")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Enter city",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isEmpty) return;

                context.read<WeatherState>().fetchWeather(city);
              },
              child: const Text("Get weather"),
            ),

            const SizedBox(height: 20),
            Consumer<WeatherState>(
              builder: (context, state, _) {
                return state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 20),
            Consumer<WeatherState>(
              builder: (context, state, _) {
                return Text(state.result, style: const TextStyle(fontSize: 20));
              },
            ),
            const SizedBox(height: 20),
            Consumer<WeatherState>(
              builder: (context, state, _) {
                if (state.threeDayForecast.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.threeDayForecast.map((text) => Text(text)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
