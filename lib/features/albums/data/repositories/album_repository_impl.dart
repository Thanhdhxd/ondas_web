import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/data/datasources/album_remote_datasource.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDataSource _dataSource;

  const AlbumRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Album>>> getAlbums({
    required int page,
    required int size,
    String? query,
    String? mode,
  }) async {
    try {
      final result = await _dataSource.getAlbums(
        page: page,
        size: size,
        query: query,
        mode: mode,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Album>> getAlbum({required String id}) async {
    try {
      final result = await _dataSource.getAlbum(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Album>> createAlbum({
    required String title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    required List<String> artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final result = await _dataSource.createAlbum(
        title: title,
        slug: slug,
        releaseDate: releaseDate,
        albumType: albumType,
        description: description,
        artistIds: artistIds,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Album>> updateAlbum({
    required String id,
    String? title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    List<String>? artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      final result = await _dataSource.updateAlbum(
        id: id,
        title: title,
        slug: slug,
        releaseDate: releaseDate,
        albumType: albumType,
        description: description,
        artistIds: artistIds,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlbum({required String id}) async {
    try {
      await _dataSource.deleteAlbum(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
