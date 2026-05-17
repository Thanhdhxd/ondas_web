import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/domain/entities/playlist.dart';

abstract class PlaylistRepository {
  Future<Either<Failure, PageResultDto<Playlist>>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? owner,
    bool? isPublic,
  });

  Future<Either<Failure, Playlist>> getPlaylist({required String id});

  Future<Either<Failure, Playlist>> createPlaylist({
    required String name,
    String? description,
    required bool isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, Playlist>> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, void>> deletePlaylist({required String id});

  Future<Either<Failure, Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<Either<Failure, Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<Either<Failure, Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  });
}
