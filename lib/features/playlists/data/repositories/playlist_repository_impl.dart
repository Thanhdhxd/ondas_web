import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/data/datasources/playlist_remote_datasource.dart';
import 'package:ondas_web/features/playlists/domain/entities/playlist.dart';
import 'package:ondas_web/features/playlists/domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistRemoteDataSource _dataSource;

  const PlaylistRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Playlist>>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? owner,
    bool? isPublic,
  }) async {
    try {
      return Right(
        await _dataSource.getPlaylists(
          page: page,
          size: size,
          query: query,
          owner: owner,
          isPublic: isPublic,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Playlist>> getPlaylist({required String id}) async {
    try {
      return Right(await _dataSource.getPlaylist(id: id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Playlist>> createPlaylist({
    required String name,
    String? description,
    required bool isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      return Right(
        await _dataSource.createPlaylist(
          name: name,
          description: description,
          isPublic: isPublic,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Playlist>> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  }) async {
    try {
      return Right(
        await _dataSource.updatePlaylist(
          id: id,
          name: name,
          description: description,
          isPublic: isPublic,
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
  Future<Either<Failure, Playlist>> addSongToPlaylist({
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
  Future<Either<Failure, Playlist>> removeSongFromPlaylist({
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
  Future<Either<Failure, Playlist>> reorderPlaylistSongs({
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
