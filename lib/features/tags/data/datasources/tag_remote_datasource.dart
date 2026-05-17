import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/tags/data/models/tag_model.dart';

abstract class TagRemoteDataSource {
  Future<PageResultDto<TagModel>> getTags({
    required int page,
    required int size,
    String? query,
    String? type,
  });

  Future<TagModel> getTag({required int id});

  Future<TagModel> createTag({
    required String name,
    String? type,
    String? colorHex,
  });

  Future<TagModel> updateTag({
    required int id,
    String? name,
    String? type,
    String? colorHex,
  });

  Future<void> deleteTag({required int id});
}
