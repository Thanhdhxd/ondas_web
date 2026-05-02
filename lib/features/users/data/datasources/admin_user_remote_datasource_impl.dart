import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/users/data/datasources/admin_user_remote_datasource.dart';
import 'package:ondas_web/features/users/data/models/admin_user_model.dart';

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final DioClient _dioClient;

  const AdminUserRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<AdminUserModel>> getUsers({
    required int page,
    required int size,
    String? keyword,
    String? role,
    bool? active,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      final trimmedKeyword = keyword?.trim();
      if (trimmedKeyword != null && trimmedKeyword.isNotEmpty) {
        queryParams['keyword'] = trimmedKeyword;
      }
      if (role != null && role.trim().isNotEmpty) {
        queryParams['role'] = role.trim();
      }
      if (active != null) {
        queryParams['active'] = active;
      }

      final response = await _dioClient.dio.get(
        ApiConstants.adminUsers,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load users',
          statusCode: response.statusCode,
        );
      }

      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        AdminUserModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AdminUserModel> getUser({required String id}) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.adminUserById(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'User not found',
          statusCode: response.statusCode,
        );
      }
      return AdminUserModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AdminUserModel> banUser({
    required String id,
    required String banReason,
  }) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiConstants.adminUserBan(id),
        data: {'banReason': banReason},
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to ban user',
          statusCode: response.statusCode,
        );
      }
      return AdminUserModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AdminUserModel> unbanUser({required String id}) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiConstants.adminUserUnban(id),
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to unban user',
          statusCode: response.statusCode,
        );
      }
      return AdminUserModel.fromJson(body['data'] as Map<String, dynamic>);
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
