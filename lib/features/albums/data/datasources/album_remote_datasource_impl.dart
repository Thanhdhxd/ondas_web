import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/albums/data/datasources/album_remote_datasource.dart';
import 'package:ondas_web/features/albums/data/models/album_model.dart';

class AlbumRemoteDataSourceImpl implements AlbumRemoteDataSource {
  final DioClient _dioClient;

  const AlbumRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<AlbumModel>> getAlbums({
    required int page,
    required int size,
    String? query,
    String? mode,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      final trimmed = query?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        queryParams['query'] = trimmed;
        queryParams['mode'] = mode ?? 'contains';
      }

      final response = await _dioClient.dio.get(
        ApiConstants.albums,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load albums',
          statusCode: response.statusCode,
        );
      }

      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        AlbumModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AlbumModel> getAlbum({required String id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.albumById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Album not found',
          statusCode: response.statusCode,
        );
      }
      return AlbumModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AlbumModel> createAlbum({
    required String title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    required List<String> artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          'title': title,
          if (slug != null) 'slug': slug,
          if (releaseDate != null) 'releaseDate': releaseDate,
          if (albumType != null) 'albumType': albumType,
          if (description != null) 'description': description,
          'artistIds': artistIds,
        },
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );

      final response = await _dioClient.dio.post(ApiConstants.albums, data: data);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create album',
          statusCode: response.statusCode,
        );
      }
      return AlbumModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AlbumModel> updateAlbum({
    required String id,
    String? title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    List<String>? artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          if (title != null) 'title': title,
          if (slug != null) 'slug': slug,
          if (releaseDate != null) 'releaseDate': releaseDate,
          if (albumType != null) 'albumType': albumType,
          if (description != null) 'description': description,
          if (artistIds != null) 'artistIds': artistIds,
        },
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );

      final response = await _dioClient.dio.put(
        ApiConstants.albumById(id),
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update album',
          statusCode: response.statusCode,
        );
      }
      return AlbumModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteAlbum({required String id}) async {
    try {
      final response = await _dioClient.dio.delete(ApiConstants.albumById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete album',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  FormData _buildFormData({
    required Map<String, dynamic> requestJson,
    List<int>? coverBytes,
    String? coverFileName,
  }) {
    final formData = FormData.fromMap({
      'data': MultipartFile.fromString(
        jsonEncode(requestJson),
        contentType: DioMediaType('application', 'json'),
      ),
    });

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
