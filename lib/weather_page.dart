import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();

  String result = ""; // текущая погода

  //String cityName = "Kyiv"; // заглушка города
  //double temperature = 20; // заглушка температуры
  //String description = "Sunny"; // заглушка описания погоды

  List<Map<String, dynamic>> threeDayForecast = []; // 3-дневный прогноз
  bool isLoading = false;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        result = "Enter a city name!";
      });
      return;
    }

    final apiKey = openWeatherApiKey;
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result =
              "Temp: ${data['main']?['temp']?.round() ?? 0}°C\n"
              "Feels like: ${data['main']?['feels_like']?.round() ?? 0}°C\n"
              "Weather: ${data['weather'] != null && data['weather'].isNotEmpty ? data['weather'][0]['description'] : 'N/A'}";
        });
      } else {
        setState(() {
          result = "City not found or API error!";
        });
      }
    } catch (e) {
      setState(() {
        result = "Network error";
      });
    }
  }

  Future<void> fetchThreeDayForecast() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    final apiKey = openWeatherApiKey;
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['list'] ?? [];

        threeDayForecast.clear();

        // берем раз в 8 блоков (примерно 24ч)
        for (int i = 0; i < list.length && threeDayForecast.length < 3; i += 8) {
          final day = list[i];
          if (day == null) continue;

          threeDayForecast.add({
            "temp": day['main']?['temp'] ?? 0,
            "feels_like": day['main']?['feels_like'] ?? 0,
            "description": day['weather'] != null && day['weather'].isNotEmpty
                ? day['weather'][0]['description']
                : "N/A",
            "date": day['dt_txt'] ?? "",
          });
        }

        setState(() {}); // обновляем UI
      } else {
        setState(() {
          threeDayForecast.clear();
          result = "Forecast not found or API error!";
        });
      }
    } catch (e) {
      setState(() {
        threeDayForecast.clear();
        result = "Network error";
      });
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
                      await fetchThreeDayForecast();
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
                children: threeDayForecast.map((day) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "${day['date'] ?? 'Unknown'}: ${day['temp']?.round() ?? 0}°C, feels like ${day['feels_like']?.round() ?? 0}°C, ${day['description'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
