import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/users/data/datasources/admin_user_remote_datasource.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/domain/repositories/admin_user_repository.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource _dataSource;

  const AdminUserRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<AdminUser>>> getUsers({
    required int page,
    required int size,
    String? keyword,
    String? role,
    bool? active,
  }) async {
    try {
      final result = await _dataSource.getUsers(
        page: page,
        size: size,
        keyword: keyword,
        role: role,
        active: active,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> getUser({required String id}) async {
    try {
      final result = await _dataSource.getUser(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> banUser({
    required String id,
    required String banReason,
  }) async {
    try {
      final result = await _dataSource.banUser(id: id, banReason: banReason);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> unbanUser({required String id}) async {
    try {
      final result = await _dataSource.unbanUser(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
