import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_locations';
  static const String _searchHistoryKey = 'search_history_locations';
  static const String _lastSelectedCityKey = 'last_selected_city';

  // FAVORITES
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_favoritesKey);
    if (jsonList == null) return [];
    return jsonList.map((item) => LocationModel.fromJson(json.decode(item))).toList();
  }

  Future<void> addFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.any((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude))) {
      favorites.add(location);
      final List<String> jsonList = favorites.map((item) => json.encode(item.toJson())).toList();
      await prefs.setStringList(_favoritesKey, jsonList);
    }
  }

  Future<void> removeFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude));
    final List<String> jsonList = favorites.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude));
  }

  // SEARCH HISTORY
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_searchHistoryKey);
    if (jsonList == null) return [];
    return jsonList.map((item) => LocationModel.fromJson(json.decode(item))).toList();
  }

  Future<void> addToHistory(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.removeWhere((item) => item.id == location.id || (item.name == location.name && item.latitude == location.latitude));
    history.insert(0, location);
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    final List<String> jsonList = history.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_searchHistoryKey, jsonList);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // LAST SELECTED LOCATION
  Future<void> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSelectedCityKey, json.encode(location.toJson()));
  }

  Future<LocationModel?> getLastSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_lastSelectedCityKey);
    if (jsonStr != null) {
      try {
        return LocationModel.fromJson(json.decode(jsonStr));
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
