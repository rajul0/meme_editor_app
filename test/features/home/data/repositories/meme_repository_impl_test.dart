import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/features/home/data/datasources/meme_local_data_source.dart';
import 'package:meme_editor_app/features/home/data/datasources/meme_remote_data_source.dart';
import 'package:meme_editor_app/features/home/data/models/meme_model.dart';
import 'package:meme_editor_app/features/home/data/repositories/meme_repository_impl.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';
import 'package:mocktail/mocktail.dart';

class MockMemeRemoteDataSource extends Mock implements MemeRemoteDataSource {}

class MockMemeLocalDataSource extends Mock implements MemeLocalDataSource {}

void main() {
  late MemeRepositoryImpl repository;
  late MockMemeRemoteDataSource mockRemoteDataSource;
  late MockMemeLocalDataSource mockLocalDataSource;

  EquatableConfig.stringify = true;

  setUp(() {
    mockRemoteDataSource = MockMemeRemoteDataSource();
    mockLocalDataSource = MockMemeLocalDataSource();
  });

  final memeModelList = [
    MemeModel(
      id: '1',
      name: 'Meme',
      imageUrl: 'url',
      width: 100,
      height: 100,
      boxCount: 2,
      captions: 1,
    ),
  ];

  final memeList = memeModelList.map((e) => e.toEntity()).toList();

  group('MemeRepositoryImpl with isOfflineMode', () {
    test('should fetch memes from local datasource when offline mode is true',
        () async {
      repository =
          MemeRepositoryImpl(mockRemoteDataSource, mockLocalDataSource, true);

      when(() => mockLocalDataSource.getCachedMemes())
          .thenAnswer((_) async => memeModelList);

      final result = await repository.getMemes();

      expect(result, isA<Right<Failure, List<Meme>>>());
      expect(result.getOrElse(() => []), memeList);

      verify(() => mockLocalDataSource.getCachedMemes()).called(1);
      verifyNever(() => mockRemoteDataSource.getMemes());
    });

    test('should return CacheFailure when local datasource throws', () async {
      repository =
          MemeRepositoryImpl(mockRemoteDataSource, mockLocalDataSource, true);

      when(() => mockLocalDataSource.getCachedMemes())
          .thenThrow(Exception('Cache Error'));

      final result = await repository.getMemes();

      expect(result, const Left(CacheFailure('Failed to load memes')));
      verify(() => mockLocalDataSource.getCachedMemes()).called(1);
      verifyNever(() => mockRemoteDataSource.getMemes());
    });

    test('should fetch memes from remote datasource when offline mode is false',
        () async {
      repository =
          MemeRepositoryImpl(mockRemoteDataSource, mockLocalDataSource, false);

      when(() => mockRemoteDataSource.getMemes())
          .thenAnswer((_) async => memeModelList);

      when(() => mockLocalDataSource.cacheMemes(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repository.getMemes();

      expect(result, isA<Right<Failure, List<Meme>>>());
      expect(result.getOrElse(() => []), memeList);
      verify(() => mockRemoteDataSource.getMemes()).called(1);
      verify(() => mockLocalDataSource.cacheMemes(memeModelList)).called(1);
      verifyNever(() => mockLocalDataSource.getCachedMemes());
    });

    test('should return CacheFailure when remote datasource throws', () async {
      repository =
          MemeRepositoryImpl(mockRemoteDataSource, mockLocalDataSource, false);

      when(() => mockRemoteDataSource.getMemes())
          .thenThrow(Exception('Remote Error'));

      final result = await repository.getMemes();

      expect(result, const Left(CacheFailure('Failed to load memes')));
      verify(() => mockRemoteDataSource.getMemes()).called(1);
    });
  });
}
