import 'package:equatable/equatable.dart';

class Meme extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final int width;
  final int height;
  final int boxCount;
  final int captions;

  const Meme({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  @override
  List<Object?> get props =>
      [id, name, imageUrl, width, height, boxCount, captions];
}
