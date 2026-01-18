import 'package:flutter/material.dart';
import 'local.dart';
import 'data/weather_repository.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();

  late final WeatherRepository _repository;

  String result = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository = WeatherRepository(openWeatherApiKey);
  }

  String parseCurrentWeather(Map<String, dynamic> data) {
    final temp = data['list'][0]['main']['temp'].round();
    final description = data['list'][0]['weather'][0]['description'];

    return "Now: $temp°C, $description";
  }

  List<String> threeDayForecast = []; // 3-дневный прогноз

  List<String> fetchThreeDayForecast(Map<String, dynamic> data) {
    final List list = data['list'] ?? [];
    final List<String> forecast = [];

    for (int i = 0; i < list.length && forecast.length < 3; i += 8) {
      final day = list[i];
      if (day == null) continue;

      final temp = (day['main']?['temp'] ?? 0).round();
      final desc = day['weather'] != null && day['weather'].isNotEmpty
          ? day['weather'][0]['description']
          : "N/A";

      forecast.add("Day ${forecast.length + 1}: $temp°C, $desc");
    }

    return forecast;
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final data = await _repository.fetchWeather(city);

      final current = parseCurrentWeather(data);
      final forecast = fetchThreeDayForecast(data);

      setState(() {
        result = current;
        threeDayForecast = forecast;
      });
    } catch (e) {
      setState(() {
        result = "Error loading weather";
        threeDayForecast.clear();
      });
    } finally {
      setState(() => isLoading = false);
    }
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
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });
                      await fetchWeather();
                      setState(() {
                        isLoading = false;
                      });
                    },
              child: const Text("Get weather"),
            ),
            const SizedBox(height: 20),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            if (threeDayForecast.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: threeDayForecast.map((text) {
                  return Text(text);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
