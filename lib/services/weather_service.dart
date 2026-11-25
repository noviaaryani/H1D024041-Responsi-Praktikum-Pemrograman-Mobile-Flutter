import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  // Request GET ke Geocoding API Open-Meteo untuk mencari kota
  Future<List<LocationModel>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final url = Uri.parse('$_geocodingBaseUrl?name=${Uri.encodeComponent(trimmed)}&count=10&language=id&format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        final List results = data['results'];
        return results.map((item) => LocationModel.fromJson(item)).toList();
      }
      return [];
    } else {
      throw Exception('Gagal melakukan pencarian lokasi (Status: ${response.statusCode})');
    }
  }

  // Request GET ke Weather Forecast API Open-Meteo
  Future<WeatherModel> getWeatherData(double latitude, double longitude) async {
    final uri = Uri.parse(
      '$_forecastBaseUrl?'
      'latitude=$latitude&'
      'longitude=$longitude&'
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&'
      'daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&'
      'timezone=auto',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil data cuaca (Status: ${response.statusCode})');
    }
  }
}
