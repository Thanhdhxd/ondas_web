import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ondas_web/features/auth/domain/entities/auth_response.dart';
import 'package:ondas_web/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final SecureStorage _secureStorage;

  const AuthRepositoryImpl(this._dataSource, this._secureStorage);

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _dataSource.login(email: email, password: password);

      const allowedRoles = {
        AppConstants.roleAdmin,
        AppConstants.roleContentManager,
      };
      if (!allowedRoles.contains(result.user.role)) {
        return const Left(InsufficientRoleFailure());
      }

      await _secureStorage.saveAccessToken(result.accessToken);
      await _secureStorage.saveRefreshToken(result.refreshToken);
      await _secureStorage.saveUserRole(result.user.role);
      await _secureStorage.saveUserDisplayName(result.user.displayName);
      await _secureStorage.saveUserEmail(result.user.email);
      return Right(result);
    } on ServerException catch (e) {
      if (e.statusCode == 401) {
        return const Left(
          UnauthorizedFailure(),
        );
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> logout({
    required String refreshToken,
  }) async {
    try {
      await _dataSource.logout(refreshToken: refreshToken);
      await _secureStorage.clearAll();
      return const Right(null);
    } on ServerException catch (e) {
      // Still clear storage even if the server call fails
      await _secureStorage.clearAll();
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
