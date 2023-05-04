import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/repo.dart';
import '../../models/search_query.dart';

class HomeRepository {
  static const String _searchQueriesKey = 'search_queries';
  static const String _favoritesKey = 'favorites';

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveFavorites(List<Repo> favoriteList) async {
    var json = jsonEncode(favoriteList.map((repo) => repo.toJson()).toList());
    print('savefavorites');
    print(json);
    await _prefs.setString(_favoritesKey, json);
  }

  List<Repo> loadFavorites() {
    var json = _prefs.getString(_favoritesKey);
    print('loadFavorites');
    print(json);
    if (json != null) {
      var data = jsonDecode(json);
      print(data);
      List<Repo> reposList = [];
      for (var repo in data) {
        reposList.add(Repo(
          id: repo['id'] ?? 0,
          name: repo['name'] ?? '',
          description: repo['description'] ?? '',
          owner: repo['owner'] ?? '',
          isFavorite: repo['isFavorite'] ?? false,
        ));
      }
      return reposList;
    } else {
      return [];
    }
  }

  Future<void> saveSearchHistory(SearchHistory searchHistory) async {
    var json = jsonEncode(searchHistory.toJson());
    await _prefs.setString(_searchQueriesKey, json);
  }

  SearchHistory loadSearchHistory() {
    var json = _prefs.getString(_searchQueriesKey);
    if (json != null) {
      var data = jsonDecode(json);
      return SearchHistory.fromJson(data);
    } else {
      return SearchHistory(queries: []);
    }
  }
}
