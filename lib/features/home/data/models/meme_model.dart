import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';

part 'meme_model.g.dart';

@HiveType(typeId: 0)
class MemeModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final int width;

  @HiveField(4)
  final int height;

  @HiveField(5)
  final int boxCount;

  @HiveField(6)
  final int captions;

  MemeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  factory MemeModel.fromJson(Map<String, dynamic> json) {
    return MemeModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['url'],
        width: json['width'],
        height: json['height'],
        boxCount: json['box_count'],
        captions: json['captions']);
  }

  Meme toEntity() {
    return Meme(
        id: id,
        name: name,
        imageUrl: imageUrl,
        width: width,
        height: height,
        boxCount: boxCount,
        captions: captions);
  }

  @override
  List<Object?> get props =>
      [id, name, imageUrl, width, height, boxCount, captions];
}
