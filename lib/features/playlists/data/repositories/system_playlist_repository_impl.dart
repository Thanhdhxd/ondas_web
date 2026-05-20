import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/data/datasources/system_playlist_remote_datasource.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';
import 'package:ondas_web/features/playlists/domain/repositories/system_playlist_repository.dart';

class SystemPlaylistRepositoryImpl implements SystemPlaylistRepository {
  final SystemPlaylistRemoteDataSource _dataSource;

  const SystemPlaylistRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<SystemPlaylist>>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? isActive,
  }) async {
    try {
      return Right(
        await _dataSource.getPlaylists(
          page: page,
          size: size,
          query: query,
          isActive: isActive,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> getPlaylist({required String id}) async {
    try {
      return Right(await _dataSource.getPlaylist(id: id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> createPlaylist({
    required String name,
    String? description,
    required bool isActive,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      return Right(
        await _dataSource.createPlaylist(
          name: name,
          description: description,
          isActive: isActive,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isActive,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      return Right(
        await _dataSource.updatePlaylist(
          id: id,
          name: name,
          description: description,
          isActive: isActive,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlaylist({required String id}) async {
    try {
      await _dataSource.deletePlaylist(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      return Right(
        await _dataSource.addSongToPlaylist(
          playlistId: playlistId,
          songId: songId,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      return Right(
        await _dataSource.removeSongFromPlaylist(
          playlistId: playlistId,
          songId: songId,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SystemPlaylist>> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  }) async {
    try {
      return Right(
        await _dataSource.reorderPlaylistSongs(
          playlistId: playlistId,
          songIds: songIds,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
