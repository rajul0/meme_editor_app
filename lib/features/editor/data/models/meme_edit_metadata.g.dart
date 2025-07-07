// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_edit_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemeEditMetadataAdapter extends TypeAdapter<MemeEditMetadata> {
  @override
  final int typeId = 4;

  @override
  MemeEditMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemeEditMetadata(
      texts: (fields[0] as List).cast<DraggableText>(),
      stickers: (fields[1] as List).cast<DraggableSticker>(),
      editorWidth: fields[2] as double,
      editorHeight: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MemeEditMetadata obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.texts)
      ..writeByte(1)
      ..write(obj.stickers)
      ..writeByte(2)
      ..write(obj.editorWidth)
      ..writeByte(3)
      ..write(obj.editorHeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemeEditMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DraggableTextAdapter extends TypeAdapter<DraggableText> {
  @override
  final int typeId = 5;

  @override
  DraggableText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraggableText(
      text: fields[0] as String,
      posX: fields[1] as double,
      posY: fields[2] as double,
      fontSize: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DraggableText obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.posX)
      ..writeByte(2)
      ..write(obj.posY)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.backgroundColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraggableTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DraggableStickerAdapter extends TypeAdapter<DraggableSticker> {
  @override
  final int typeId = 6;

  @override
  DraggableSticker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraggableSticker(
      assetPath: fields[0] as String,
      posX: fields[1] as double,
      posY: fields[2] as double,
      width: fields[3] as double,
      height: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DraggableSticker obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.assetPath)
      ..writeByte(1)
      ..write(obj.posX)
      ..writeByte(2)
      ..write(obj.posY)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraggableStickerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
