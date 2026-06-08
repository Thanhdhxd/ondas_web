import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

abstract class GetActivityLogsUseCase {
  Future<Either<Failure, PageResultDto<ActivityLog>>> call(
    GetActivityLogsParams params,
  );
}

class GetActivityLogsParams extends Equatable {
  final String? actorId;
  final String? searchUser;
  final String? action;
  final String? from;
  final String? to;
  final int page;
  final int size;

  const GetActivityLogsParams({
    this.actorId,
    this.searchUser,
    this.action,
    this.from,
    this.to,
    required this.page,
    required this.size,
  });

  @override
  List<Object?> get props =>
      [actorId, searchUser, action, from, to, page, size];
}
