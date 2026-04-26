import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/data/datasources/artist_remote_datasource.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource _dataSource;

  const ArtistRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Artist>>> getArtists({
    required int page,
    required int size,
    String? query,
  }) async {
    try {
      final result = await _dataSource.getArtists(
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
  Future<Either<Failure, Artist>> getArtist({required String id}) async {
    try {
      final result = await _dataSource.getArtist(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Artist>> createArtist({
    required String name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      final result = await _dataSource.createArtist(
        name: name,
        slug: slug,
        bio: bio,
        country: country,
        avatarBytes: avatarBytes,
        avatarFileName: avatarFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Artist>> updateArtist({
    required String id,
    String? name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      final result = await _dataSource.updateArtist(
        id: id,
        name: name,
        slug: slug,
        bio: bio,
        country: country,
        avatarBytes: avatarBytes,
        avatarFileName: avatarFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteArtist({required String id}) async {
    try {
      await _dataSource.deleteArtist(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
