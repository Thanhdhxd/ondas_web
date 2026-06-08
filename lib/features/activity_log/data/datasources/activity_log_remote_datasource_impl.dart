import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/activity_log/data/datasources/activity_log_remote_datasource.dart';
import 'package:ondas_web/features/activity_log/data/models/activity_log_model.dart';

class ActivityLogRemoteDataSourceImpl implements ActivityLogRemoteDataSource {
  final DioClient _dioClient;

  const ActivityLogRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PageResultDto<ActivityLogModel>> getLogs({
    String? actorId,
    String? searchUser,
    String? action,
    String? from,
    String? to,
    required int page,
    required int size,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'size': size};
      if (actorId != null && actorId.isNotEmpty) params['actorId'] = actorId;
      if (searchUser != null && searchUser.isNotEmpty) {
        params['searchUser'] = searchUser;
      }
      if (action != null && action.isNotEmpty) params['action'] = action;
      if (from != null && from.isNotEmpty) params['from'] = from;
      if (to != null && to.isNotEmpty) params['to'] = to;

      final response = await _dioClient.dio.get(
        ApiConstants.adminActivityLogs,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load activity logs',
          statusCode: response.statusCode,
        );
      }
      return PageResultDto.fromJson(
        body['data'] as Map<String, dynamic>,
        ActivityLogModel.fromJson,
      );
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
