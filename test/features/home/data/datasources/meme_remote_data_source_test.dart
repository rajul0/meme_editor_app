import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/core/network/api_client.dart';
import 'package:meme_editor_app/features/home/data/datasources/meme_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

final String apiUrl = dotenv.env['API_URL'] ?? "";

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MemeRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = MemeRemoteDataSourceImpl(mockApiClient, apiUrl);
  });

  final responseBody = json.encode({
    'success': true,
    'data': {
      'memes': [
        {
          'id': 'test123',
          'name': 'Meme 1',
          'url': 'https://example.com/meme1.png',
          'width': 500,
          'height': 300,
          'box_count': 2,
          'captions': 1,
        },
      ],
    },
  });

  test('should return List<MemeModel> when the response code is 200', () async {
    when(() => mockApiClient.get(any()))
        .thenAnswer((_) async => http.Response(responseBody, 200));

    // actual
    final result = await dataSource.getMemes();

    // expeted and assert
    expect(result.length, 1);
    expect(result.first.id, 'test123');
    verify(() => mockApiClient.get(any())).called(1);
  });

  test('should throw ServerFailure when the response code is not 200',
      () async {
    when(() => mockApiClient.get(any()))
        .thenAnswer((_) async => http.Response('Error', 404));

    // actual
    final call = dataSource.getMemes;

    // expected and assert
    expect(() => call(), throwsA(isA<ServerFailure>()));
    verify(() => mockApiClient.get(any())).called(1);
  });

  test('should throw ServerFailure on exception', () async {
    when(() => mockApiClient.get(any()))
        .thenThrow(Exception('Unexpected error'));

    // actual
    final call = dataSource.getMemes;

    // expected and assert
    expect(() => call(), throwsA(isA<ServerFailure>()));
    verify(() => mockApiClient.get(any())).called(1);
  });
}
