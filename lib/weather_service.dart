import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/weather_model.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apikey&units=metric'));

    if (response.statusCode == 200) {
      //print('----------------------------------------------------');
      //print('JSON Response: ${response.body}');
      //print('----------------------------------------------------');
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          '-------------------- Failed to load Weather Data ---------------------');
    }
  }

  Future<String> getCurrentCity() async {
    // Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current loction
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placement objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placement
    String? city = placemark[0].locality;

    return city ?? "City Name";
  }
}
