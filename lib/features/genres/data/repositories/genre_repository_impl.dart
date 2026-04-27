import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/data/datasources/genre_remote_datasource.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';

class GenreRepositoryImpl implements GenreRepository {
  final GenreRemoteDataSource _dataSource;

  const GenreRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Genre>>> getGenres({
    required int page,
    required int size,
    String? query,
  }) async {
    try {
      final result = await _dataSource.getGenres(
        page: page,
        size: size,
        query: query,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Genre>> getGenre({required int id}) async {
    try {
      final result = await _dataSource.getGenre(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Genre>> createGenre({
    required String name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final result = await _dataSource.createGenre(
        name: name,
        slug: slug,
        description: description,
        coverUrl: coverUrl,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Genre>> updateGenre({
    required int id,
    String? name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final result = await _dataSource.updateGenre(
        id: id,
        name: name,
        slug: slug,
        description: description,
        coverUrl: coverUrl,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGenre({required int id}) async {
    try {
      await _dataSource.deleteGenre(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
