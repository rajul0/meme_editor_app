import 'package:equatable/equatable.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Meme> memes;
  final List<Meme> filteredMemes;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final bool isSearching;

  const HomeLoaded({
    required this.memes,
    required this.filteredMemes,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.isSearching = false,
  });

  HomeLoaded copyWith({
    List<Meme>? memes,
    List<Meme>? filteredMemes,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    bool? isSearching,
  }) {
    return HomeLoaded(
      memes: memes ?? this.memes,
      filteredMemes: filteredMemes ?? this.filteredMemes,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props =>
      [memes, filteredMemes, isLoadingMore, hasReachedEnd, isSearching];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
