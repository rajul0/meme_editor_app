// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemeModelAdapter extends TypeAdapter<MemeModel> {
  @override
  final int typeId = 0;

  @override
  MemeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      width: fields[3] as int,
      height: fields[4] as int,
      boxCount: fields[5] as int,
      captions: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MemeModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.boxCount)
      ..writeByte(6)
      ..write(obj.captions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
