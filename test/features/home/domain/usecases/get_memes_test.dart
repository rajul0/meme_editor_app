import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';
import 'package:meme_editor_app/features/home/domain/repositories/meme_repository.dart';
import 'package:meme_editor_app/features/home/domain/usecases/get_memes.dart';
import 'package:mocktail/mocktail.dart';

class MockMemeRepository extends Mock implements MemeRepository {}

void main() {
  late GetMemes getMemes;
  late MockMemeRepository mockMemeRepository;

  setUp(() {
    mockMemeRepository = MockMemeRepository();
    getMemes = GetMemes(mockMemeRepository);
  });

  final memeList = [
    Meme(
      id: '1',
      name: 'Meme1',
      imageUrl: 'https://example.com/meme1.png',
      width: 500,
      height: 300,
      boxCount: 2,
      captions: 1,
    ),
  ];

  test('should get meme list from repository', () async {
    when(() => mockMemeRepository.getMemes())
        .thenAnswer((_) async => Right(memeList));

    // actual
    final result = await getMemes.execute();

    // expected and assert
    expect(result, Right(memeList));
    verify(() => mockMemeRepository.getMemes()).called(1);
    verifyNoMoreInteractions(mockMemeRepository);
  });

  test('should return failure when repository fails', () async {
    when(() => mockMemeRepository.getMemes())
        .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

    // actual
    final result = await getMemes.execute();

    // expected and assert
    expect(result, const Left(ServerFailure('Server Error')));
    verify(() => mockMemeRepository.getMemes()).called(1);
    verifyNoMoreInteractions(mockMemeRepository);
  });
}
