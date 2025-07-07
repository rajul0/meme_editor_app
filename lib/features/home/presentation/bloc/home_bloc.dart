import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';
import 'package:meme_editor_app/features/home/domain/usecases/get_memes.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_event.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMemes getMemes;
  List<Meme> _allMemes = [];
  final int _limit = 18;

  HomeBloc({required this.getMemes}) : super(const HomeInitial()) {
    on<LoadMemes>(_onLoadMemes);
    on<RefreshMemes>(_onRefreshMemes);
    on<LoadMoreMemes>(_onLoadMore);
    on<SearchMemes>(_onSearchMemes);
  }

  Future<void> _onLoadMemes(LoadMemes event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final result = await getMemes.execute();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (memes) {
        _allMemes = memes;

        final initialMemes = _allMemes.take(_limit).toList();

        emit(HomeLoaded(
          memes: _allMemes,
          filteredMemes: initialMemes,
          isLoadingMore: false,
          hasReachedEnd: initialMemes.length >= memes.length,
          isSearching: false,
        ));
      },
    );
  }

  Future<void> _onLoadMore(LoadMoreMemes event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    if (currentState.isLoadingMore ||
        currentState.hasReachedEnd ||
        currentState.isSearching) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    await Future.delayed(const Duration(milliseconds: 500));

    final nextItems =
        _allMemes.skip(currentState.filteredMemes.length).take(_limit).toList();

    final updatedList = [...currentState.filteredMemes, ...nextItems];
    final hasReachedEnd =
        updatedList.length >= _allMemes.length || nextItems.isEmpty;

    emit(currentState.copyWith(
      filteredMemes: updatedList,
      isLoadingMore: false,
      hasReachedEnd: hasReachedEnd,
    ));
  }

  Future<void> _onRefreshMemes(
      RefreshMemes event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final result = await getMemes.execute();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (memes) {
        _allMemes = memes;

        final initialMemes = _allMemes.take(_limit).toList();

        emit(HomeLoaded(
          memes: _allMemes,
          filteredMemes: initialMemes,
          isLoadingMore: false,
          hasReachedEnd: initialMemes.length >= _allMemes.length,
          isSearching: false,
        ));
      },
    );
  }

  void _onSearchMemes(SearchMemes event, Emitter<HomeState> emit) {
    final query = event.query.toLowerCase();
    final currentState = state as HomeLoaded;

    if (query.isEmpty) {
      final initialMemes = _allMemes.take(_limit).toList();
      emit(currentState.copyWith(
        filteredMemes: initialMemes,
        isSearching: false,
      ));
    } else {
      final filtered = _allMemes
          .where((meme) => meme.name.toLowerCase().contains(query))
          .toList();

      emit(currentState.copyWith(
        filteredMemes: filtered,
        isSearching: true,
        hasReachedEnd: true,
      ));
    }
  }
}
