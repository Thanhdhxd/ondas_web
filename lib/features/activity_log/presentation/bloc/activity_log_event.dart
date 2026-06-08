import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

abstract class ActivityLogEvent extends Equatable {
  const ActivityLogEvent();

  @override
  List<Object?> get props => [];
}

class ActivityLogLoadEvent extends ActivityLogEvent {
  final String? actorId;
  final String? searchUser;
  final String? action;
  final String? from;
  final String? to;
  final int page;
  final int size;

  const ActivityLogLoadEvent({
    this.actorId,
    this.searchUser,
    this.action,
    this.from,
    this.to,
    required this.page,
    required this.size,
  });

  @override
  List<Object?> get props => [actorId, searchUser, action, from, to, page, size];
}
