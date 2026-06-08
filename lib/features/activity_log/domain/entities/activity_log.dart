import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final int id;
  final String actorId;
  final String actorEmail;
  final String actorDisplayName;
  final String action;
  final String resourceType;
  final String? resourceId;
  final String? resourceName;
  final String? metadata;
  final String? ipAddress;
  final String? createdAt;

  const ActivityLog({
    required this.id,
    required this.actorId,
    required this.actorEmail,
    required this.actorDisplayName,
    required this.action,
    required this.resourceType,
    this.resourceId,
    this.resourceName,
    this.metadata,
    this.ipAddress,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    actorId,
    actorEmail,
    actorDisplayName,
    action,
    resourceType,
    resourceId,
    resourceName,
    metadata,
    ipAddress,
    createdAt,
  ];
}
