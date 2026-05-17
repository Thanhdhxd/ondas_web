import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/playlists/data/datasources/playlist_remote_datasource.dart';
import 'package:ondas_web/features/playlists/data/models/playlist_model.dart';

class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final DioClient _dioClient;

  const PlaylistRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<PlaylistModel>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? owner,
    bool? isPublic,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.playlists,
        queryParameters: {
          'page': page,
          'size': size,
          if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
          if (owner != null) 'owner': owner,
          if (isPublic != null) 'isPublic': isPublic,
        },
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load playlists',
          statusCode: response.statusCode,
        );
      }
      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        PlaylistModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> getPlaylist({required String id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.playlistById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Playlist not found',
          statusCode: response.statusCode,
        );
      }
      return PlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> createPlaylist({
    required String name,
    String? description,
    required bool isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.playlists,
        data: _buildFormData(
          requestJson: {
            'name': name,
            if (description != null) 'description': description,
            'isPublic': isPublic,
          },
          fileBytes: coverBytes,
          fileName: coverFileName,
        ),
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create playlist',
          statusCode: response.statusCode,
        );
      }
      return PlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.playlistById(id),
        data: _buildFormData(
          requestJson: {
            if (name != null) 'name': name,
            if (description != null) 'description': description,
            if (isPublic != null) 'isPublic': isPublic,
          },
          fileBytes: coverBytes,
          fileName: coverFileName,
        ),
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update playlist',
          statusCode: response.statusCode,
        );
      }
      return PlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.playlistSongs(playlistId),
        data: {'songId': songId},
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.playlistSongById(playlistId, songId),
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PlaylistModel> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.playlistSongsReorder(playlistId),
        data: {'songIds': songIds},
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  PlaylistModel _parsePlaylistResponse(Response<dynamic> response) {
    final body = response.data as Map<String, dynamic>;
    if (body['success'] != true) {
      throw ServerException(
        message: body['message'] as String? ?? 'Playlist operation failed',
        statusCode: response.statusCode,
      );
    }
    return PlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deletePlaylist({required String id}) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.playlistById(id),
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete playlist',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  FormData _buildFormData({
    required Map<String, dynamic> requestJson,
    List<int>? fileBytes,
    String? fileName,
  }) {
    final formData = FormData.fromMap({
      'data': MultipartFile.fromString(
        jsonEncode(requestJson),
        contentType: DioMediaType('application', 'json'),
      ),
    });
    if (fileBytes != null && fileName != null) {
      formData.files.add(
        MapEntry(
          'cover',
          MultipartFile.fromBytes(fileBytes, filename: fileName),
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
