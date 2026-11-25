import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class SearchViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _history = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SearchViewModel() {
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    _favorites = await _storageService.getFavorites();
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _weatherService.searchLocations(query);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(LocationModel location) async {
    final exists = _favorites.any((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude));
    if (exists) {
      await _storageService.removeFavorite(location);
    } else {
      await _storageService.addFavorite(location);
    }
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  bool isLocationFavorite(LocationModel location) {
    return _favorites.any((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude));
  }

  Future<void> onLocationSelected(LocationModel location) async {
    await _storageService.addToHistory(location);
    await _storageService.saveLastSelectedLocation(location);
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    _history = [];
    notifyListeners();
  }
}
