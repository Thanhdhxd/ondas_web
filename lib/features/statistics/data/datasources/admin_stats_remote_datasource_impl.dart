import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/features/statistics/data/datasources/admin_stats_remote_datasource.dart';
import 'package:ondas_web/features/statistics/data/models/admin_stats_model.dart';

class AdminStatsRemoteDataSourceImpl implements AdminStatsRemoteDataSource {
  final DioClient _dioClient;

  const AdminStatsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<TopSongModel>> getTopSongs({
    String? from,
    String? to,
    int limit = 10,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (from != null) params['from'] = from;
      if (to != null) params['to'] = to;

      final response = await _dioClient.dio.get(
        ApiConstants.adminStatsTopSongs,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load top songs',
          statusCode: response.statusCode,
        );
      }
      return (body['data'] as List<dynamic>)
          .map((e) => TopSongModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<TopArtistModel>> getTopArtists({
    String? from,
    String? to,
    int limit = 10,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (from != null) params['from'] = from;
      if (to != null) params['to'] = to;

      final response = await _dioClient.dio.get(
        ApiConstants.adminStatsTopArtists,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load top artists',
          statusCode: response.statusCode,
        );
      }
      return (body['data'] as List<dynamic>)
          .map((e) => TopArtistModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<DailyPlayCountModel>> getPlaysDaily({
    String? from,
    String? to,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (from != null) params['from'] = from;
      if (to != null) params['to'] = to;

      final response = await _dioClient.dio.get(
        ApiConstants.adminStatsPlaysDaily,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] as String? ?? 'Failed to load play counts',
          statusCode: response.statusCode,
        );
      }
      return (body['data'] as List<dynamic>)
          .map((e) => DailyPlayCountModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<DauMauStatsModel> getDauMau({String? date}) async {
    try {
      final params = <String, dynamic>{};
      if (date != null) params['date'] = date;

      final response = await _dioClient.dio.get(
        ApiConstants.adminStatsDauMau,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message:
              body['message'] as String? ?? 'Failed to load DAU/MAU stats',
          statusCode: response.statusCode,
        );
      }
      return DauMauStatsModel.fromJson(
        body['data'] as Map<String, dynamic>,
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
