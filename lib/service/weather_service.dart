import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static final BASE_URL = dotenv.env['BASE_URL'];
  static final API_KEY = dotenv.env['API_KEY'];

  Future<Weather> getWeather(String cityName) async {
    final url = "$BASE_URL?q=$cityName&appid=$API_KEY";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error fetch");
    }
  }

  Future<String> getCurrentCity() async {
    //request permission to user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    print("Placemarks: ${placemarks}");

    return placemarks[0].locality ?? "";
  }
}
