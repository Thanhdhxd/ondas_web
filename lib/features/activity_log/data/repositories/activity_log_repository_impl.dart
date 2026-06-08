import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/activity_log/data/datasources/activity_log_remote_datasource.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';
import 'package:ondas_web/features/activity_log/domain/repositories/activity_log_repository.dart';

class ActivityLogRepositoryImpl implements ActivityLogRepository {
  final ActivityLogRemoteDataSource _dataSource;

  const ActivityLogRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<ActivityLog>>> getLogs({
    String? actorId,
    String? searchUser,
    String? action,
    String? from,
    String? to,
    required int page,
    required int size,
  }) async {
    try {
      final result = await _dataSource.getLogs(
        actorId: actorId,
        searchUser: searchUser,
        action: action,
        from: from,
        to: to,
        page: page,
        size: size,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
