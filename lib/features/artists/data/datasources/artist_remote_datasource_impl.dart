import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/artists/data/datasources/artist_remote_datasource.dart';
import 'package:ondas_web/features/artists/data/models/artist_model.dart';

class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final DioClient _dioClient;

  const ArtistRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<ArtistModel>> getArtists({
    required int page,
    required int size,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      final response = await _dioClient.dio.get(
        ApiConstants.artists,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load artists',
          statusCode: response.statusCode,
        );
      }
      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        ArtistModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ArtistModel> getArtist({required String id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.artistById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Artist not found',
          statusCode: response.statusCode,
        );
      }
      return ArtistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ArtistModel> createArtist({
    required String name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          'name': name,
          if (slug != null) 'slug': slug,
          if (bio != null) 'bio': bio,
          if (country != null) 'country': country,
        },
        fileBytes: avatarBytes,
        fileName: avatarFileName,
        filePartName: 'avatar',
      );
      final response = await _dioClient.dio.post(
        ApiConstants.artists,
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create artist',
          statusCode: response.statusCode,
        );
      }
      return ArtistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ArtistModel> updateArtist({
    required String id,
    String? name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          if (name != null) 'name': name,
          if (slug != null) 'slug': slug,
          if (bio != null) 'bio': bio,
          if (country != null) 'country': country,
        },
        fileBytes: avatarBytes,
        fileName: avatarFileName,
        filePartName: 'avatar',
      );
      final response = await _dioClient.dio.put(
        ApiConstants.artistById(id),
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update artist',
          statusCode: response.statusCode,
        );
      }
      return ArtistModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteArtist({required String id}) async {
    try {
      final response = await _dioClient.dio.delete(ApiConstants.artistById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete artist',
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
    required String filePartName,
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
          filePartName,
          MultipartFile.fromBytes(fileBytes, filename: fileName),
        ),
      );
    }
    return formData;
  }

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = (e.response?.data as Map<String, dynamic>?)?['message']
            as String? ??
        e.message ??
        'Network error';
    throw ServerException(message: message, statusCode: statusCode);
  }
}
