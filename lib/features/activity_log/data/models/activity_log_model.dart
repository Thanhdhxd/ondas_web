import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

class ActivityLogModel extends ActivityLog {
  const ActivityLogModel({
    required super.id,
    required super.actorId,
    required super.actorEmail,
    required super.actorDisplayName,
    required super.action,
    required super.resourceType,
    super.resourceId,
    super.resourceName,
    super.metadata,
    super.ipAddress,
    super.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      actorId: json['actorId'] as String? ?? '',
      actorEmail: json['actorEmail'] as String? ?? '',
      actorDisplayName: json['actorDisplayName'] as String? ?? '',
      action: json['action'] as String? ?? '',
      resourceType: json['resourceType'] as String? ?? '',
      resourceId: json['resourceId'] as String?,
      resourceName: json['resourceName'] as String?,
      metadata: json['metadata'] as String?,
      ipAddress: json['ipAddress'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
