import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'meme_edit_metadata.g.dart';

@HiveType(typeId: 1)
class MemeEditMetadata extends HiveObject {
  @HiveField(0)
  final List<DraggableText> texts;
  @HiveField(1)
  final List<DraggableSticker> stickers;
  @HiveField(2)
  final double editorWidth;
  @HiveField(3)
  final double editorHeight;

  MemeEditMetadata({
    required this.texts,
    required this.stickers,
    required this.editorWidth,
    required this.editorHeight,
  });
}

@HiveType(typeId: 2)
class DraggableText extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final double posX;

  @HiveField(2)
  final double posY;

  @HiveField(3)
  final double fontSize;

  @HiveField(4)
  final int backgroundColorValue;

  Color get backgroundColor => Color(backgroundColorValue);

  DraggableText({
    required this.text,
    required this.posX,
    required this.posY,
    this.fontSize = 20,
    Color backgroundColor = const Color(0x00000000),
  }) : backgroundColorValue = backgroundColor.value;

  DraggableText copyWith({
    String? text,
    double? posX,
    double? posY,
    double? fontSize,
    Color? backgroundColor,
  }) {
    return DraggableText(
      text: text ?? this.text,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      fontSize: fontSize ?? this.fontSize,
      backgroundColor: backgroundColor ?? Color(backgroundColorValue),
    );
  }
}

@HiveType(typeId: 3)
class DraggableSticker extends HiveObject {
  @HiveField(0)
  final String assetPath;

  @HiveField(1)
  final double posX;

  @HiveField(2)
  final double posY;

  @HiveField(3)
  final double width;

  @HiveField(4)
  final double height;

  DraggableSticker({
    required this.assetPath,
    required this.posX,
    required this.posY,
    this.width = 100,
    this.height = 100,
  });

  DraggableSticker copyWith({
    String? assetPath,
    double? posX,
    double? posY,
    double? width,
    double? height,
  }) {
    return DraggableSticker(
      assetPath: assetPath ?? this.assetPath,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
