import 'package:hive/hive.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/features/home/data/models/meme_model.dart';

abstract class MemeLocalDataSource {
  Future<void> cacheMemes(List<MemeModel> memes);
  Future<List<MemeModel>> getCachedMemes();
}

class MemeLocalDataSourceImpl implements MemeLocalDataSource {
  static const String memeBoxName = 'memeBox';

  @override
  Future<void> cacheMemes(List<MemeModel> memes) async {
    try {
      final box = await Hive.openBox<MemeModel>(memeBoxName);
      await box.clear();
      await box.addAll(memes);
    } catch (e) {
      throw CacheFailure('Failed to cache memes: $e');
    }
  }

  @override
  Future<List<MemeModel>> getCachedMemes() async {
    try {
      final box = await Hive.openBox<MemeModel>(memeBoxName);
      return box.values.toList();
    } catch (e) {
      throw CacheFailure('Failed to get cached memes: $e');
    }
  }
}
