import 'package:dartz/dartz.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import '../entities/export_result.dart';
import 'dart:typed_data';

abstract class ExportRepository {
  Future<Either<Failure, ExportResult>> saveImage(Uint8List imageBytes);
  Future<Either<Failure, void>> shareImage(Uint8List imageBytes);
}
