import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ondas_web/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }

      return AuthResponseModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = (e.response?.data as Map<String, dynamic>?)?['message']
              as String? ??
          e.message ??
          'Network error';
      throw ServerException(message: message, statusCode: statusCode);
    }
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      await _dioClient.dio.delete(
        ApiConstants.logout,
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = (e.response?.data as Map<String, dynamic>?)?['message']
              as String? ??
          e.message ??
          'Network error';
      throw ServerException(message: message, statusCode: statusCode);
    }
  }
}
