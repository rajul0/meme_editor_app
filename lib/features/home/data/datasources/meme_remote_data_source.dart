import 'dart:convert';
import 'package:meme_editor_app/core/error/failure.dart';
import 'package:meme_editor_app/core/network/api_client.dart';
import 'package:meme_editor_app/features/home/data/models/meme_model.dart';

abstract class MemeRemoteDataSource {
  Future<List<MemeModel>> getMemes();
}

class MemeRemoteDataSourceImpl implements MemeRemoteDataSource {
  final ApiClient apiClient;
  final String apiUrl;

  MemeRemoteDataSourceImpl(this.apiClient, this.apiUrl);

  @override
  Future<List<MemeModel>> getMemes() async {
    try {
      final response = await apiClient.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> memesData = data['data']['memes'];

        return memesData.map((e) => MemeModel.fromJson(e)).toList();
      } else {
        throw ServerFailure('Failed to load memes: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
}
