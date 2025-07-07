import 'package:dartz/dartz.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import '../entities/meme.dart';
import '../repositories/meme_repository.dart';

class GetMemes {
  final MemeRepository repository;

  GetMemes(this.repository);

  Future<Either<Failure, List<Meme>>> execute() {
    return repository.getMemes();
  }
}
