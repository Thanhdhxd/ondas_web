import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/genres/data/datasources/genre_remote_datasource.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';

class GenreRemoteDataSourceImpl implements GenreRemoteDataSource {
  final DioClient _dioClient;

  const GenreRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<GenreModel>> getGenres({
    required int page,
    required int size,
    String? query,
  }) async {
    try {
      final trimmedQuery = query?.trim();
      final hasQuery = trimmedQuery != null && trimmedQuery.isNotEmpty;

      final response = hasQuery
          ? await _dioClient.dio.get(
              ApiConstants.genresSearch,
              queryParameters: {
                'query': trimmedQuery,
                'mode': 'contains',
                'page': page,
                'size': size,
              },
            )
          : await _dioClient.dio.get(ApiConstants.genres);

      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load genres',
          statusCode: response.statusCode,
        );
      }

      if (hasQuery) {
        return PageResultDto.fromJson(
          body['data'] as Map<String, dynamic>,
          GenreModel.fromJson,
        );
      }

      final genres = (body['data'] as List<dynamic>)
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final totalElements = genres.length;
      final totalPages = totalElements == 0
          ? 1
          : ((totalElements - 1) ~/ size) + 1;
      final start = page * size;
      final end = (start + size) > totalElements
          ? totalElements
          : (start + size);
      final items = start >= totalElements
          ? <GenreModel>[]
          : genres.sublist(start, end);

      return PageResultDto<GenreModel>(
        items: items,
        page: page,
        size: size,
        totalElements: totalElements,
        totalPages: totalPages,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<GenreModel> getGenre({required int id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.genreById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Genre not found',
          statusCode: response.statusCode,
        );
      }
      return GenreModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<GenreModel> createGenre({
    required String name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          'name': name,
          if (slug != null) 'slug': slug,
          if (description != null) 'description': description,
          if (coverUrl != null) 'coverUrl': coverUrl,
        },
        fileBytes: coverBytes,
        fileName: coverFileName,
        filePartName: 'cover',
      );
      final response = await _dioClient.dio.post(
        ApiConstants.genres,
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create genre',
          statusCode: response.statusCode,
        );
      }
      return GenreModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<GenreModel> updateGenre({
    required int id,
    String? name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final data = _buildFormData(
        requestJson: {
          if (name != null) 'name': name,
          if (slug != null) 'slug': slug,
          if (description != null) 'description': description,
          if (coverUrl != null) 'coverUrl': coverUrl,
        },
        fileBytes: coverBytes,
        fileName: coverFileName,
        filePartName: 'cover',
      );
      final response = await _dioClient.dio.put(
        ApiConstants.genreById(id),
        data: data,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update genre',
          statusCode: response.statusCode,
        );
      }
      return GenreModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteGenre({required int id}) async {
    try {
      final response = await _dioClient.dio.delete(ApiConstants.genreById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete genre',
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
    final message =
        (e.response?.data as Map<String, dynamic>?)?['message'] as String? ??
        e.message ??
        'Network error';
    throw ServerException(message: message, statusCode: statusCode);
  }
}
