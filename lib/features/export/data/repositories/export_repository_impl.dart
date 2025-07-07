import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/export_result.dart';
import '../../domain/repositories/export_repository.dart';
import '../../../../core/error/failure.dart';
import 'package:path_provider/path_provider.dart';

class ExportRepositoryImpl implements ExportRepository {
  @override
  Future<Either<Failure, ExportResult>> saveImage(Uint8List imageBytes) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(imageBytes);
      if (result['isSuccess']) {
        return Right(ExportResult(true));
      } else {
        return const Left(ServerFailure('Failed to save image'));
      }
    } else {
      return const Left(PermissionFailure('Storage permission denied'));
    }
  }

  @override
  Future<Either<Failure, void>> shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_meme.png')
          .writeAsBytes(imageBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Check out my meme!');
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure('Failed to share image: $e'));
    }
  }
}
