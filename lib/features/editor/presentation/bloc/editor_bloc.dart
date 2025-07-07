import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:hive/hive.dart';
import 'package:meme_editor_app/features/editor/data/models/meme_edit_metadata.dart';
import './editor_event.dart';
import './editor_state.dart';

class MemeEditorBloc extends Bloc<MemeEditorEvent, MemeEditorState> {
  final List<MemeEditorState> _undoStack = [];
  final List<MemeEditorState> _redoStack = [];

  void _saveStateForUndo() {
    _undoStack.add(state);
    _redoStack.clear();
  }

  MemeEditorBloc() : super(MemeEditorState()) {
    on<InitEditor>((event, emit) {
      emit(state.copyWith(
        editorWidth: event.width,
        editorHeight: event.height,
      ));
    });

    on<AddText>((event, emit) {
      _saveStateForUndo();

      final updatedTexts = List<DraggableText>.from(state.texts)
        ..add(DraggableText(
          text: event.text,
          posX: 150,
          posY: 300,
          fontSize: 24,
          backgroundColor: event.backgroundColor,
        ));
      emit(state.copyWith(texts: updatedTexts));
    });

    on<AddSticker>((event, emit) {
      _saveStateForUndo();
      final updatedStickers = List<DraggableSticker>.from(state.stickers)
        ..add(
            DraggableSticker(assetPath: event.assetPath, posX: 100, posY: 100));
      emit(state.copyWith(stickers: updatedStickers));
    });

    on<UpdateTextPosition>((event, emit) {
      _saveStateForUndo();
      final updatedTexts = List<DraggableText>.from(state.texts);
      final currentText = updatedTexts[event.index];
      updatedTexts[event.index] = currentText.copyWith(
        posX: event.posX,
        posY: event.posY,
      );
      emit(state.copyWith(texts: updatedTexts));
    });

    on<UpdateStickerPosition>((event, emit) {
      _saveStateForUndo();
      final updatedStickers = List<DraggableSticker>.from(state.stickers);
      final currentSticker = updatedStickers[event.index];
      updatedStickers[event.index] = currentSticker.copyWith(
        posX: event.posX,
        posY: event.posY,
      );
      emit(state.copyWith(stickers: updatedStickers));
    });

    on<UpdateTextSize>((event, emit) {
      _saveStateForUndo();
      final updatedTexts = List<DraggableText>.from(state.texts);
      final currentText = updatedTexts[event.index];
      updatedTexts[event.index] = currentText.copyWith(
        fontSize: event.fontSize,
      );
      emit(state.copyWith(texts: updatedTexts));
    });

    on<UpdateStickerSize>((event, emit) {
      _saveStateForUndo();
      final updatedStickers = List<DraggableSticker>.from(state.stickers);
      updatedStickers[event.index] = updatedStickers[event.index].copyWith(
        width: event.width,
        height: event.height,
      );
      emit(state.copyWith(stickers: updatedStickers));
    });

    on<LoadMetadata>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final box = await Hive.openBox<MemeEditMetadata>('meme_edits');
      final metadata = box.get(event.imageUrl);

      if (metadata != null) {
        emit(state.copyWith(
          texts: metadata.texts,
          stickers: metadata.stickers,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          texts: [],
          stickers: [],
          isLoading: false,
        ));
      }
    });

    on<SaveAndExport>((event, emit) async {
      emit(state.copyWith(isExporting: true));
      try {
        final metadata = MemeEditMetadata(
          texts: state.texts,
          stickers: state.stickers,
          editorWidth: state.editorWidth,
          editorHeight: state.editorHeight,
        );

        final box = Hive.box<MemeEditMetadata>('meme_edits');
        await box.put(event.imageUrl, metadata);

        // Render Boundary
        final boundary = event.previewKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
        if (boundary == null) {
          throw Exception('Failed to find render boundary');
        }

        // Generate Image
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final imageBytes = byteData?.buffer.asUint8List();

        if (imageBytes == null) {
          throw Exception('Failed to generate image bytes');
        }

        // Emit hasil export
        emit(state.copyWith(
          isExporting: false,
          exportedImage: imageBytes,
        ));
      } catch (e) {
        emit(state.copyWith(isExporting: false));
      }
    });

    on<ClearMetadata>((event, emit) async {
      final box = Hive.box<MemeEditMetadata>('meme_edits');

      await box.delete(event.imageUrl);

      // Reset state sticker dan text
      emit(state.copyWith(
        texts: [],
        stickers: [],
      ));
    });

    on<ResetExportedImage>((event, emit) {
      emit(state.copyWith(exportedImage: null));
    });

    on<UndoEdit>((event, emit) {
      if (_undoStack.isNotEmpty) {
        _redoStack.add(state);
        final previousState = _undoStack.removeLast();
        emit(previousState);
      }
    });

    on<RedoEdit>((event, emit) {
      if (_redoStack.isNotEmpty) {
        _undoStack.add(state);
        final nextState = _redoStack.removeLast();
        emit(nextState);
      }
    });
  }
}
