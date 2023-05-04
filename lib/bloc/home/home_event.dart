import '../../models/repo.dart';

abstract class HomeEvent {}

class ClearSearchQueryEvent extends HomeEvent{}
class SearchTextEvent extends HomeEvent {}
class InitHistAndFavEvent extends HomeEvent {}
class ChangeSearchQueryEvent extends HomeEvent {
  String changedSearchQuery;
  ChangeSearchQueryEvent(this.changedSearchQuery);
}

class ChangeFavoriteByIndexEvent extends HomeEvent {
  Repo repo;
  ChangeFavoriteByIndexEvent(this.repo);
}