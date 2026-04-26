import 'package:dio/dio.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';

class JwtInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  // Used internally to refresh tokens without causing infinite loops
  late final Dio _refreshDio;

  JwtInterceptor(this._secureStorage) {
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        await _secureStorage.clearAll();
        handler.next(err);
        return;
      }

      try {
        final response = await _refreshDio.post(
          ApiConstants.refresh,
          data: {'refreshToken': refreshToken},
        );

        final data = response.data['data'];
        await _secureStorage.saveAccessToken(data['accessToken'] as String);
        await _secureStorage.saveRefreshToken(data['refreshToken'] as String);

        // Retry original request with new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${data['accessToken']}';
        final retryResponse = await _refreshDio.fetch(options);
        handler.resolve(retryResponse);
      } on DioException {
        await _secureStorage.clearAll();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
