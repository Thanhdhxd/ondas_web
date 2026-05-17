import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/songs/data/datasources/song_remote_datasource.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';
import 'package:ondas_web/features/tags/data/models/tag_model.dart';

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final DioClient _dioClient;

  const SongRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<SongModel>> getSongs({
    required int page,
    required int size,
    String? query,
    String? mode,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      final trimmedQuery = query?.trim();
      if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
        queryParams['query'] = trimmedQuery;
        queryParams['mode'] = mode ?? 'contains';
      }

      final response = await _dioClient.dio.get(
        ApiConstants.songs,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load songs',
          statusCode: response.statusCode,
        );
      }

      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        SongModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SongModel> getSong({required String id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.songById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Song not found',
          statusCode: response.statusCode,
        );
      }
      return SongModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SongModel> createSong({
    required String title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    required List<String> artistIds,
    required List<int> genreIds,
    required List<int> audioBytes,
    required String audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
    String? lyrics,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          'title': title,
          if (albumId != null) 'albumId': albumId,
          if (trackNumber != null) 'trackNumber': trackNumber,
          if (releaseDate != null) 'releaseDate': releaseDate,
          'artistIds': artistIds,
          'genreIds': genreIds,
          if (lyrics != null && lyrics.isNotEmpty) 'lyrics': lyrics,
        },
        audioBytes: audioBytes,
        audioFileName: audioFileName,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );

      final response = await _dioClient.dio.post(ApiConstants.songs, data: data);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create song',
          statusCode: response.statusCode,
        );
      }
      return SongModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SongModel> updateSong({
    required String id,
    String? title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    List<String>? artistIds,
    List<int>? genreIds,
    bool? active,
    List<int>? audioBytes,
    String? audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          if (title != null) 'title': title,
          if (albumId != null) 'albumId': albumId,
          if (trackNumber != null) 'trackNumber': trackNumber,
          if (releaseDate != null) 'releaseDate': releaseDate,
          if (artistIds != null) 'artistIds': artistIds,
          if (genreIds != null) 'genreIds': genreIds,
          if (active != null) 'active': active,
        },
        audioBytes: audioBytes,
        audioFileName: audioFileName,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );

      final response = await _dioClient.dio.put(
        ApiConstants.songById(id),
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update song',
          statusCode: response.statusCode,
        );
      }
      return SongModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<TagModel>> getSongTags({required String songId}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.songTags(songId));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load song tags',
          statusCode: response.statusCode,
        );
      }
      final data = body['data'] as List<dynamic>? ?? const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(TagModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<TagModel>> replaceSongTags({
    required String songId,
    required List<int> tagIds,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.songTags(songId),
        data: {'tagIds': tagIds},
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update song tags',
          statusCode: response.statusCode,
        );
      }
      final data = body['data'] as List<dynamic>? ?? const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(TagModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteSong({required String id}) async {
    try {
      final response = await _dioClient.dio.delete(ApiConstants.songById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete song',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  FormData _buildFormData({
    required Map<String, dynamic> requestJson,
    List<int>? audioBytes,
    String? audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
  }) {
    final formData = FormData.fromMap({
      'data': MultipartFile.fromString(
        jsonEncode(requestJson),
        contentType: DioMediaType('application', 'json'),
      ),
    });

    if (audioBytes != null && audioFileName != null) {
      formData.files.add(
        MapEntry(
          'audio',
          MultipartFile.fromBytes(audioBytes, filename: audioFileName),
        ),
      );
    }

    if (coverBytes != null && coverFileName != null) {
      formData.files.add(
        MapEntry(
          'cover',
          MultipartFile.fromBytes(coverBytes, filename: coverFileName),
        ),
      );
    }

    return formData;
  }

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message =
        (e.response?.data as Map<String, dynamic>?)?['message'] as String? ??
        e.message ??
        'Network error';
    throw ServerException(message: message, statusCode: statusCode);
  }
}
