import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:leads_do_it_test/screens/favorites_screen.dart';
import 'package:leads_do_it_test/main.dart';
import 'package:leads_do_it_test/models/repo.dart';
import 'package:leads_do_it_test/models/search_query.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var repoList = ["one", "two", "three"];
  List<bool> _checked = List.filled(5, false);
  String _searchQuery = '';
  List<Repo> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopping(),
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        _buildSearchField(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16, top: 18, bottom: 18),
            child: Text(
              _searchResults.isEmpty ? 'Search history' : 'What we have found',
              style: Styles.textHistory,
            ),
          ),
        ),
        _searchResults.isEmpty ? showSearchHistory() : showFoundResults(),
      ],
    );
  }

  Widget showFoundResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.layer_1,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  changeFavorite(index);
                });
              },
              child: ListTile(
                trailing: IconButton(
                  icon: _searchResults[index].isFavorite
                      ? SvgPicture.asset(
                          'assets/imgs/favorite_active.svg',
                        )
                      : SvgPicture.asset(
                          'assets/imgs/favorite_not_active.svg',
                        ),
                  onPressed: () {
                    setState(() {
                      changeFavorite(index);
                    });
                  },
                ),
                title: Text(_searchResults[index].name),
                // subtitle: Text(_searchResults[index].description),
              ),
            ),
          );
        },
      ),
    );
  }

  void changeFavorite(int index) {
    _searchResults[index].isFavorite = !_searchResults[index].isFavorite;
    if (_searchResults[index].isFavorite) {
      favoriteList.add(_searchResults[index]);
    } else {
      favoriteList.remove(_searchResults[index]);
    }
  }

  Widget showSearchHistory() {
    return Expanded(
        child: ListView.builder(
            itemCount: searchHistory.queries.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(searchHistory.queries[index].query),
                subtitle:
                    Text(searchHistory.queries[index].timeStamp.toString()),
              );
            }));
  }

  AppBar _buildTopping() {
    return AppBar(
      elevation: 1,
      backgroundColor: AppColors.main,
      title: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                Strings.appName,
                style: Styles.textHeader,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const FavouriteScreen()),
                  );
                },
                child: SvgPicture.asset(
                  'assets/imgs/favourites.svg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          border: Border.all(color: AppColors.primary, width: 2.0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          onChanged: (text) {
            setState(() {
              _searchQuery = text;
            });
          },
          onSubmitted: (text) {
            _performSearch();
          },
          decoration: InputDecoration(
            labelText: Strings.search,
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  top: 18, bottom: 18, left: 20, right: 20),
              child: SvgPicture.asset(
                'assets/imgs/search.svg',
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(
                'assets/imgs/close.svg',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch() async {
    var headers = {
      'Authorization': 'Bearer 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'
    };
    var response = await http.get(
        Uri.parse(
            'https://api.github.com/search/repositories?q=$_searchQuery&sort=stars&order=desc'),
        headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['items'];

      List<Repo> reposList = [];
      for (var repo in data) {
        reposList.add(Repo(
            id: repo['id'] ?? 0,
            name: repo['name'] ?? '',
            description: repo['description'] ?? '',
            owner: repo['owner']?['login'] ?? ''));
      }
      print(reposList);

      var query = SearchQuery(_searchQuery, DateTime.now());
      searchHistory.queries.add(query);

      setState(() {
        _searchResults = reposList;
      });
    }
  }

  Widget _buildResultItem(BuildContext context, int index) {
    Repo repo = _searchResults[index];

    return Card(
      child: ListTile(
        title: Text(repo.name),
        subtitle: Text(repo.owner),
        trailing: IconButton(
          icon: Icon(repo.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            setState(() {
              repo.isFavorite = !repo.isFavorite;
            });
            _saveFavoriteList();
          },
        ),
      ),
    );
  }

  void _saveSearchHistory() async {
    var prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(searchHistory.toJson());
    await prefs.setString('search_history', json);
  }

  void _saveFavoriteList() async {
    var prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(favoriteList.map((repo) => repo.toJson()).toList());
    await prefs.setString('favorite_list', json);
  }
}
