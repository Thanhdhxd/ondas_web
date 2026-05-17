import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/tags/data/datasources/tag_remote_datasource.dart';
import 'package:ondas_web/features/tags/data/models/tag_model.dart';

class TagRemoteDataSourceImpl implements TagRemoteDataSource {
  final DioClient _dioClient;

  const TagRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<TagModel>> getTags({
    required int page,
    required int size,
    String? query,
    String? type,
  }) async {
    try {
      final trimmedQuery = query?.trim();
      final hasQuery = trimmedQuery != null && trimmedQuery.isNotEmpty;
      final hasType = type != null && type.isNotEmpty;
      final response = hasQuery && !hasType
          ? await _dioClient.dio.get(
              ApiConstants.tagsSearch,
              queryParameters: {
                'query': trimmedQuery,
                'mode': 'contains',
                'page': page,
                'size': size,
              },
            )
          : await _dioClient.dio.get(
              ApiConstants.tags,
              queryParameters: {if (hasType) 'type': type},
            );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load tags',
          statusCode: response.statusCode,
        );
      }

      if (hasQuery && !hasType) {
        return PageResultDto.fromJson(
          body['data'] as Map<String, dynamic>,
          TagModel.fromJson,
        );
      }

      var tags = (body['data'] as List<dynamic>)
          .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (hasQuery) {
        final normalizedQuery = trimmedQuery.toLowerCase();
        tags = tags
            .where((tag) => tag.name.toLowerCase().contains(normalizedQuery))
            .toList();
      }
      final totalElements = tags.length;
      final totalPages = totalElements == 0
          ? 1
          : ((totalElements - 1) ~/ size) + 1;
      final start = page * size;
      final end = start + size > totalElements ? totalElements : start + size;

      return PageResultDto<TagModel>(
        items: start >= totalElements ? <TagModel>[] : tags.sublist(start, end),
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
  Future<TagModel> getTag({required int id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.tagById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Tag not found',
          statusCode: response.statusCode,
        );
      }
      return TagModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<TagModel> createTag({
    required String name,
    String? type,
    String? colorHex,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.tags,
        data: {
          'name': name,
          if (type != null) 'type': type,
          if (colorHex != null) 'colorHex': colorHex,
        },
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to create tag',
          statusCode: response.statusCode,
        );
      }
      return TagModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<TagModel> updateTag({
    required int id,
    String? name,
    String? type,
    String? colorHex,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.tagById(id),
        data: {
          if (name != null) 'name': name,
          if (type != null) 'type': type,
          if (colorHex != null) 'colorHex': colorHex,
        },
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to update tag',
          statusCode: response.statusCode,
        );
      }
      return TagModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteTag({required int id}) async {
    try {
      final response = await _dioClient.dio.delete(ApiConstants.tagById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to delete tag',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
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
