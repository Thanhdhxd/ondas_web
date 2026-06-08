import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/activity_log/data/models/activity_log_model.dart';

abstract class ActivityLogRemoteDataSource {
  Future<PageResultDto<ActivityLogModel>> getLogs({
    String? actorId,
    String? searchUser,
    String? action,
    String? from,
    String? to,
    required int page,
    required int size,
  });
}
