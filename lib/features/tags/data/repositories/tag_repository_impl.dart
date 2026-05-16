import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/tags/data/datasources/tag_remote_datasource.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';
import 'package:ondas_web/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagRemoteDataSource _dataSource;

  const TagRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Tag>>> getTags({
    required int page,
    required int size,
    String? query,
    String? type,
  }) async {
    try {
      return Right(
        await _dataSource.getTags(
          page: page,
          size: size,
          query: query,
          type: type,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Tag>> getTag({required int id}) async {
    try {
      return Right(await _dataSource.getTag(id: id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Tag>> createTag({
    required String name,
    String? type,
    String? colorHex,
  }) async {
    try {
      return Right(
        await _dataSource.createTag(name: name, type: type, colorHex: colorHex),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Tag>> updateTag({
    required int id,
    String? name,
    String? type,
    String? colorHex,
  }) async {
    try {
      return Right(
        await _dataSource.updateTag(
          id: id,
          name: name,
          type: type,
          colorHex: colorHex,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTag({required int id}) async {
    try {
      await _dataSource.deleteTag(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
