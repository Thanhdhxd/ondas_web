import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

abstract class ActivityLogRepository {
  Future<Either<Failure, PageResultDto<ActivityLog>>> getLogs({
    String? actorId,
    String? searchUser,
    String? action,
    String? from,
    String? to,
    required int page,
    required int size,
  });
}
