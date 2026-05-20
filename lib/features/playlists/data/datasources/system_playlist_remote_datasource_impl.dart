import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/playlists/data/datasources/system_playlist_remote_datasource.dart';
import 'package:ondas_web/features/playlists/data/models/system_playlist_model.dart';

class SystemPlaylistRemoteDataSourceImpl implements SystemPlaylistRemoteDataSource {
  final DioClient _dioClient;

  const SystemPlaylistRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<SystemPlaylistModel>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? isActive,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.adminSystemPlaylists,
        queryParameters: {
          'page': page,
          'size': size,
          if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
          if (isActive != null) 'isActive': isActive,
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
        SystemPlaylistModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> getPlaylist({required String id}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.adminSystemPlaylistById(id),
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Playlist not found',
          statusCode: response.statusCode,
        );
      }
      return SystemPlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> createPlaylist({
    required String name,
    String? description,
    required bool isActive,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.adminSystemPlaylists,
        data: _buildFormData(
          requestJson: {
            'name': name,
            if (description != null) 'description': description,
            'isActive': isActive,
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
      return SystemPlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isActive,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.adminSystemPlaylistById(id),
        data: _buildFormData(
          requestJson: {
            if (name != null) 'name': name,
            if (description != null) 'description': description,
            if (isActive != null) 'isActive': isActive,
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
      return SystemPlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.adminSystemPlaylistSongs(playlistId),
        data: {'songId': songId},
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.adminSystemPlaylistSongById(playlistId, songId),
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<SystemPlaylistModel> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.adminSystemPlaylistSongsReorder(playlistId),
        data: {'songIds': songIds},
      );
      return _parsePlaylistResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  SystemPlaylistModel _parsePlaylistResponse(Response<dynamic> response) {
    final body = response.data as Map<String, dynamic>;
    if (body['success'] != true) {
      throw ServerException(
        message: body['message'] as String? ?? 'Playlist operation failed',
        statusCode: response.statusCode,
      );
    }
    return SystemPlaylistModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deletePlaylist({required String id}) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.adminSystemPlaylistById(id),
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

