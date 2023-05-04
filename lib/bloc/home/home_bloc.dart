import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leads_do_it_test/bloc/home/home_event.dart';
import 'package:http/http.dart' as http;
import 'package:leads_do_it_test/bloc/home/home_repository.dart';

import '../../main.dart';
import '../../models/repo.dart';
import '../../models/search_query.dart';
import '../../themes/strings.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepo = HomeRepository();
  HomeBloc() : super(HomeState.initial()) {
    on<SearchTextEvent>(_onSearchTextEvent);
    on<ChangeSearchQueryEvent>(_onChangeSearchQueryEvent);
    on<InitHistAndFavEvent>(_onInitHistAndFavEvent);
    on<ChangeFavoriteByIndexEvent>(_onChangeFavoriteByIndexEvent);
    on<ClearSearchQueryEvent>(_onClearSearchQueryEvent);

    add(InitHistAndFavEvent());
  }
  Future<void> _onClearSearchQueryEvent(
      ClearSearchQueryEvent event, Emitter emitter) async {
    emitter(state.copyWith(searchQuery: '', searchResults: []));
  }

  Future<void> _onSearchTextEvent(
      SearchTextEvent event, Emitter emitter) async {
    var headers = {
      'Authorization': 'Bearer ${Strings.token}'
    };
    var response = await http.get(
        Uri.parse(
            'https://api.github.com/search/repositories?q=${state.searchQuery}&sort=stars&order=desc'),
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

      var query = SearchQuery(state.searchQuery, DateTime.now());
      state.searchHistory.queries
          .add(query);
      homeRepo.saveSearchHistory(state.searchHistory);
      emitter(
          state.copyWith(searchResults: reposList, searchResultsEmpty: false));
    } else {
      print('error occurred resp code is: ${response.statusCode}');
      emitter(state.copyWith(searchResultsEmpty: true));
    }
  }

  Future<void> _onChangeSearchQueryEvent(
      ChangeSearchQueryEvent event, Emitter emitter) async {
    emitter(state.copyWith(searchQuery: event.changedSearchQuery));
  }

  Future<void> _onInitHistAndFavEvent(
      InitHistAndFavEvent event, Emitter emitter) async {
    await homeRepo.initPrefs();

    List<Repo> favRepo = homeRepo.loadFavorites();
    favRepo.removeWhere((element) => !element.isFavorite);

    SearchHistory sh = homeRepo.loadSearchHistory();

    emitter(state.copyWith(favoriteList: favRepo, searchHistory: sh));
  }

  Future<void> _onChangeFavoriteByIndexEvent(
      ChangeFavoriteByIndexEvent event, Emitter emitter) async {

    event.repo.isFavorite = !event.repo.isFavorite;
    if (event.repo.isFavorite && state.favoriteList
        .where((element) => element.id == event.repo.id).isEmpty) {
        state.favoriteList.add(event.repo);
    } else {
      state.favoriteList.remove(event.repo);
      List<Repo> inSearchResults = state.searchResults.where((element) => element.id == event.repo.id).toList();
      if(inSearchResults.isNotEmpty) inSearchResults.forEach((element) {element.isFavorite = false;});
    }
    homeRepo.saveFavorites(state.favoriteList);
    emitter(state.copyWith());
  }
}
