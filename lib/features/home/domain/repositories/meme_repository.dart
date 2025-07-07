import 'package:dartz/dartz.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import '../entities/meme.dart';

abstract class MemeRepository {
  Future<Either<Failure, List<Meme>>> getMemes();
}
