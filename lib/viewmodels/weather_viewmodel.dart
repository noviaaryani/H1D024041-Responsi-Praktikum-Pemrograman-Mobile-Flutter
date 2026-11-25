import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weatherData;
  LocationModel? _currentLocation;
  String? _errorMessage;

  WeatherStatus get status => _status;
  WeatherModel? get weatherData => _weatherData;
  LocationModel? get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;

  WeatherViewModel() {
    initDefaultLocation();
  }

  Future<void> initDefaultLocation() async {
    final lastLocation = await _storageService.getLastSelectedLocation();
    if (lastLocation != null) {
      _currentLocation = lastLocation;
    } else {
      // Default ke Jakarta jika baru pertama kali buka aplikasi
      _currentLocation = LocationModel(
        id: 1642911,
        name: 'Jakarta',
        latitude: -6.2146,
        longitude: 106.8451,
        country: 'Indonesia',
        admin1: 'Jakarta',
      );
    }
    fetchWeather();
  }

  Future<void> setLocation(LocationModel location) async {
    _currentLocation = location;
    await _storageService.saveLastSelectedLocation(location);
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    if (_currentLocation == null) return;

    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _weatherService.getWeatherData(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
      _status = WeatherStatus.success;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }
}
