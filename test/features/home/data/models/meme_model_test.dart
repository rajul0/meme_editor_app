import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/features/home/data/models/meme_model.dart';
import 'package:meme_editor_app/features/home/domain/entities/meme.dart';

void main() {
  const memeJson = {
    'id': 'test123',
    'name': 'Funny Meme',
    'url': 'https://example.com/meme.png',
    'width': 500,
    'height': 300,
    'box_count': 2,
    'captions': 1,
  };

  final memeModel = MemeModel(
    id: 'test123',
    name: 'Funny Meme',
    imageUrl: 'https://example.com/meme.png',
    width: 500,
    height: 300,
    boxCount: 2,
    captions: 1,
  );

  test('should mapping JSON to MemeModel Instance correctly', () {
    final result = MemeModel.fromJson(memeJson);

    expect(result.id, 'test123');
    expect(result.name, 'Funny Meme');
    expect(result.imageUrl, 'https://example.com/meme.png');
    expect(result.width, 500);
    expect(result.height, 300);
    expect(result.boxCount, 2);
    expect(result.captions, 1);
  });

  test('should convert MemeModel to Meme entity correctly', () {
    final entity = memeModel.toEntity();

    expect(entity, isA<Meme>());
    expect(entity.id, memeModel.id);
    expect(entity.name, memeModel.name);
    expect(entity.imageUrl, memeModel.imageUrl);
    expect(entity.width, memeModel.width);
    expect(entity.height, memeModel.height);
    expect(entity.boxCount, memeModel.boxCount);
    expect(entity.captions, memeModel.captions);
  });
}
