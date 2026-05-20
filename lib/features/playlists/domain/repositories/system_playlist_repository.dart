import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';

abstract class SystemPlaylistRepository {
  Future<Either<Failure, PageResultDto<SystemPlaylist>>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? isActive,
  });

  Future<Either<Failure, SystemPlaylist>> getPlaylist({required String id});

  Future<Either<Failure, SystemPlaylist>> createPlaylist({
    required String name,
    String? description,
    required bool isActive,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, SystemPlaylist>> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isActive,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, void>> deletePlaylist({required String id});

  Future<Either<Failure, SystemPlaylist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<Either<Failure, SystemPlaylist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<Either<Failure, SystemPlaylist>> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  });
}
