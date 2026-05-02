import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/users/data/models/admin_user_model.dart';

abstract class AdminUserRemoteDataSource {
  Future<PageResultDto<AdminUserModel>> getUsers({
    required int page,
    required int size,
    String? keyword,
    String? role,
    bool? active,
  });

  Future<AdminUserModel> getUser({required String id});

  Future<AdminUserModel> banUser({
    required String id,
    required String banReason,
  });

  Future<AdminUserModel> unbanUser({required String id});
}
