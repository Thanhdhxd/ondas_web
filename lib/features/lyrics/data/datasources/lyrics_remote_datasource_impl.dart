import 'package:dio/dio.dart';

import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/lyrics/data/datasources/lyrics_remote_datasource.dart';
import 'package:ondas_web/features/lyrics/data/models/lyrics_model.dart';

class LyricsRemoteDataSourceImpl implements LyricsRemoteDataSource {
  final DioClient _dioClient;

  const LyricsRemoteDataSourceImpl(this._dioClient);

  Dio get _dio => _dioClient.dio;

  Never _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (e.response?.statusCode == 403) {
      throw const ForbiddenException();
    }
    if (e.response?.statusCode == 404) {
      final body = e.response?.data as Map<String, dynamic>?;
      throw ServerException(
        message: body?['message'] as String? ?? 'Resource not found',
        statusCode: 404,
      );
    }
    if (e.response?.statusCode == 409) {
      final body = e.response?.data as Map<String, dynamic>?;
      throw ServerException(
        message: body?['message'] as String? ?? 'Conflict',
        statusCode: 409,
      );
    }
    throw ServerException(
      message: e.message ?? 'Network error',
      statusCode: e.response?.statusCode,
    );
  }

  @override
  Future<LyricsModel> getLyrics({required String songId}) async {
    try {
      final response = await _dio.get(ApiConstants.songLyrics(songId));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load lyrics',
          statusCode: response.statusCode,
        );
      }
      return LyricsModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<LyricsModel> createLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<Map<String, dynamic>>? syncedLines,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      if (language != null) requestBody['language'] = language;
      if (plainText != null) requestBody['plainText'] = plainText;
      if (syncedLines != null) requestBody['syncedLines'] = syncedLines;

      final response = await _dio.post(
        ApiConstants.songLyrics(songId),
        data: requestBody,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create lyrics',
          statusCode: response.statusCode,
        );
      }
      return LyricsModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<LyricsModel> updateLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<Map<String, dynamic>>? syncedLines,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      if (language != null) requestBody['language'] = language;
      if (plainText != null) requestBody['plainText'] = plainText;
      if (syncedLines != null) requestBody['syncedLines'] = syncedLines;

      final response = await _dio.patch(
        ApiConstants.songLyrics(songId),
        data: requestBody,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update lyrics',
          statusCode: response.statusCode,
        );
      }
      return LyricsModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteLyrics({required String songId}) async {
    try {
      final response = await _dio.delete(ApiConstants.songLyrics(songId));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete lyrics',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
