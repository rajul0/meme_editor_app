import 'package:dartz/dartz.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import '../datasources/meme_remote_data_source.dart';
import '../datasources/meme_local_data_source.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';
import 'package:meme_editor_app/features/home/domain/repositories/meme_repository.dart';

class MemeRepositoryImpl implements MemeRepository {
  final MemeRemoteDataSource remoteDataSource;
  final MemeLocalDataSource localDataSource;
  final bool isOfflineMode;

  MemeRepositoryImpl(
      this.remoteDataSource, this.localDataSource, this.isOfflineMode);

  @override
  Future<Either<Failure, List<Meme>>> getMemes() async {
    try {
      if (isOfflineMode) {
        final cached = await localDataSource.getCachedMemes();
        return Right(cached.map((e) => e.toEntity()).toList());
      } else {
        final remote = await remoteDataSource.getMemes();
        await localDataSource.cacheMemes(remote);
        return Right(remote.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      return const Left(CacheFailure('Failed to load memes'));
    }
  }
}
