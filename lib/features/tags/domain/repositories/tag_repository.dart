import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

abstract class TagRepository {
  Future<Either<Failure, PageResultDto<Tag>>> getTags({
    required int page,
    required int size,
    String? query,
    String? type,
  });

  Future<Either<Failure, Tag>> getTag({required int id});

  Future<Either<Failure, Tag>> createTag({
    required String name,
    String? type,
    String? colorHex,
  });

  Future<Either<Failure, Tag>> updateTag({
    required int id,
    String? name,
    String? type,
    String? colorHex,
  });

  Future<Either<Failure, void>> deleteTag({required int id});
}
