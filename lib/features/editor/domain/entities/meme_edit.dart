import 'package:meme_editor_app/features/editor/domain/entities/meme_sticker.dart';
import 'package:meme_editor_app/features/editor/domain/entities/meme_text.dart';

class MemeEdit {
  final List<MemeText> texts;
  final List<MemeSticker> stickers;
  final double editorWidth;
  final double editorHeight;

  MemeEdit({
    required this.texts,
    required this.stickers,
    required this.editorWidth,
    required this.editorHeight,
  });
}
