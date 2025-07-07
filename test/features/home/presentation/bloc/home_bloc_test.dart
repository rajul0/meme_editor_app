import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_event.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';
import 'package:meme_editor_app/features/home/domain/usecases/get_memes.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_bloc.dart';

// Mocking usecase
class MockGetMemes extends Mock implements GetMemes {}

void main() {
  late HomeBloc homeBloc;
  late MockGetMemes mockGetMemes;

  final testMemes = [
    Meme(
        id: "test123",
        name: "Meme 1",
        imageUrl: "https://example.com/meme1.jpg",
        width: 1200,
        height: 1200,
        boxCount: 2,
        captions: 1),
    Meme(
        id: "test456",
        name: "Meme 2",
        imageUrl: "https://example.com/meme2.jpg",
        width: 600,
        height: 908,
        boxCount: 3,
        captions: 2),
  ];

  setUp(() {
    mockGetMemes = MockGetMemes();
    homeBloc = HomeBloc(getMemes: mockGetMemes);
  });

  tearDown(() {
    homeBloc.close();
  });

  test('initial state is HomeInitial', () {
    expect(homeBloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeLoaded] when LoadMemes event is added and success',
    build: () {
      when(() => mockGetMemes.execute())
          .thenAnswer((_) async => Right(testMemes));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadMemes()),
    expect: () => [
      const HomeLoading(),
      HomeLoaded(
        memes: testMemes,
        filteredMemes: testMemes.take(18).toList(),
        isLoadingMore: false,
        hasReachedEnd: testMemes.length <= 18,
        isSearching: false,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeError] when LoadMemes fails',
    build: () {
      when(() => mockGetMemes.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadMemes()),
    expect: () => [
      HomeLoading(),
      HomeError(message: 'Failed'),
    ],
  );
}
