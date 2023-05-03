import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leads_do_it_test/models/repo.dart';
import 'package:leads_do_it_test/models/search_query.dart';
import 'package:leads_do_it_test/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SearchHistory searchHistory = SearchHistory(queries: []);
List<Repo> favoriteList = [];

void main() {
  // var prefs = await SharedPreferences.getInstance();
  // var json = prefs.getString('search_history');
  // if (json != null) {
  //   var data = jsonDecode(json);
  //   searchHistory = SearchHistory.fromJson(data);
  // }

  // json = prefs.getString('favorite_list');
  // if (json != null) {
  //   var data = jsonDecode(json);
  //   favoriteList = data.map((repoData) => Repo.fromJson(repoData)).toList();
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github repos list',
      home: SplashScreen(),
    );
  }
}
