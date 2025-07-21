import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/service/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _weatherService = WeatherService();
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition) {
      case 'Clouds':
        return 'assets/clouds.json';
      case 'Thunderstorm':
        return 'assets/thunderstorm.json';
      case 'Drizzle':
        return 'assets/drizzle.json';
      case 'Rain':
        return 'assets/rain.json';
      case 'Snow':
        return 'assets/snow.json';
      case 'Atmosphere':
        return 'assets/atmosphere.json';
      case 'Clear':
        return 'assets/clear.json';
      default:
        throw Exception("Invalid Main Condition");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weather?.cityName ?? ""),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Text("${_weather?.temperature.round()} °C"),
                  Text(_weather?.mainCondition ?? ""),
                ],
              ),
      ),
    );
  }
}
