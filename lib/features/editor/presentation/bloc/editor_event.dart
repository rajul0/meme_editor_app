import 'package:flutter/material.dart';

abstract class MemeEditorEvent {}

class InitEditor extends MemeEditorEvent {
  final double width;
  final double height;

  InitEditor(this.width, this.height);
}

class AddText extends MemeEditorEvent {
  final String text;
  final Color backgroundColor;

  AddText(this.text, this.backgroundColor);
}

class AddSticker extends MemeEditorEvent {
  final String assetPath;

  AddSticker(this.assetPath);
}

class UpdateTextPosition extends MemeEditorEvent {
  final int index;
  final double posX;
  final double posY;

  UpdateTextPosition(this.index, this.posX, this.posY);
}

class UpdateStickerPosition extends MemeEditorEvent {
  final int index;
  final double posX;
  final double posY;

  UpdateStickerPosition(this.index, this.posX, this.posY);
}

class LoadMetadata extends MemeEditorEvent {
  final String imageUrl;

  LoadMetadata(this.imageUrl);
}

class SaveMetadata extends MemeEditorEvent {
  final String imageUrl;

  SaveMetadata(this.imageUrl);
}

class SaveAndExport extends MemeEditorEvent {
  final String imageUrl;
  final GlobalKey previewKey;

  SaveAndExport(this.imageUrl, this.previewKey);
}

class ResetExportedImage extends MemeEditorEvent {}

class ClearMetadata extends MemeEditorEvent {
  final String imageUrl;

  ClearMetadata(this.imageUrl);
}

class UpdateTextSize extends MemeEditorEvent {
  final int index;
  final double fontSize;
  UpdateTextSize(this.index, this.fontSize);
}

class UpdateStickerSize extends MemeEditorEvent {
  final int index;
  final double width;
  final double height;

  UpdateStickerSize(this.index, this.width, this.height);
}

class UndoEdit extends MemeEditorEvent {}

class RedoEdit extends MemeEditorEvent {}
