import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

abstract class ActivityLogState extends Equatable {
  const ActivityLogState();

  @override
  List<Object?> get props => [];
}

class ActivityLogInitial extends ActivityLogState {
  const ActivityLogInitial();
}

class ActivityLogLoading extends ActivityLogState {
  const ActivityLogLoading();
}

class ActivityLogLoaded extends ActivityLogState {
  final List<ActivityLog> logs;
  final int page;
  final int totalPages;
  final int totalElements;

  const ActivityLogLoaded({
    required this.logs,
    required this.page,
    required this.totalPages,
    required this.totalElements,
  });

  @override
  List<Object?> get props => [logs, page, totalPages, totalElements];
}

class ActivityLogError extends ActivityLogState {
  final String message;

  const ActivityLogError({required this.message});

  @override
  List<Object?> get props => [message];
}
