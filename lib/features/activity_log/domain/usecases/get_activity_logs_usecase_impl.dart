import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';
import 'package:ondas_web/features/activity_log/domain/repositories/activity_log_repository.dart';
import 'package:ondas_web/features/activity_log/domain/usecases/get_activity_logs_usecase.dart';

class GetActivityLogsUseCaseImpl implements GetActivityLogsUseCase {
  final ActivityLogRepository _repository;

  const GetActivityLogsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<ActivityLog>>> call(
    GetActivityLogsParams params,
  ) {
    return _repository.getLogs(
      actorId: params.actorId,
      searchUser: params.searchUser,
      action: params.action,
      from: params.from,
      to: params.to,
      page: params.page,
      size: params.size,
    );
  }
}
