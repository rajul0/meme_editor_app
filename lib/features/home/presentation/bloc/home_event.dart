abstract class HomeEvent {}

class LoadMemes extends HomeEvent {}

class LoadMoreMemes extends HomeEvent {}

class RefreshMemes extends HomeEvent {}

class SearchMemes extends HomeEvent {
  final String query;

  SearchMemes(this.query);
}
