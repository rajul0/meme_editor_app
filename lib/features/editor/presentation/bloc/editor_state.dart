import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meme_editor_app/features/editor/data/models/meme_edit_metadata.dart';

class MemeEditorState extends Equatable {
  final List<DraggableText> texts;
  final List<DraggableSticker> stickers;
  final double editorWidth;
  final double editorHeight;
  final bool isLoading;
  final bool isExporting;
  final Uint8List? exportedImage;

  const MemeEditorState({
    this.texts = const [],
    this.stickers = const [],
    this.editorWidth = 1200,
    this.editorHeight = 1200,
    this.isLoading = false,
    this.isExporting = false,
    this.exportedImage,
  });

  MemeEditorState copyWith({
    List<DraggableText>? texts,
    List<DraggableSticker>? stickers,
    double? editorWidth,
    double? editorHeight,
    bool? isLoading,
    bool? isExporting,
    Uint8List? exportedImage,
    bool? showHandles,
  }) {
    return MemeEditorState(
      texts: texts ?? this.texts,
      stickers: stickers ?? this.stickers,
      editorWidth: editorWidth ?? this.editorWidth,
      editorHeight: editorHeight ?? this.editorHeight,
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      exportedImage: exportedImage,
    );
  }

  @override
  List<Object?> get props => [
        texts,
        stickers,
        isLoading,
        editorWidth,
        editorHeight,
        isLoading,
        isExporting,
        exportedImage,
      ];
}
