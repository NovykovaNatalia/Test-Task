import '../../models/repo.dart';
import '../../models/search_query.dart';

class HomeState {
  String searchQuery;
  SearchHistory searchHistory;

  List<Repo> searchResults;
  List<Repo> favoriteList;
  bool searchResultsEmpty;

  HomeState({
    required this.searchResults,
    required this.favoriteList,
    required this.searchQuery,
    required this.searchHistory,
    required this.searchResultsEmpty,
  });

  factory HomeState.initial() => HomeState(
        searchResults: [],
        favoriteList: [],
        searchQuery: '',
        searchResultsEmpty: false,
        searchHistory: SearchHistory(queries: []),
      );

  HomeState copyWith({
    List<Repo>? searchResults,
    List<Repo>? favoriteList,
    String? searchQuery,
    SearchHistory? searchHistory,
    bool? searchResultsEmpty,
  }) {
    return HomeState(
      searchResults: searchResults ?? this.searchResults,
      favoriteList: favoriteList ?? this.favoriteList,
      searchQuery: searchQuery ?? this.searchQuery,
      searchHistory: searchHistory ?? this.searchHistory,
      searchResultsEmpty: searchResultsEmpty ?? this.searchResultsEmpty,
    );
  }
}
