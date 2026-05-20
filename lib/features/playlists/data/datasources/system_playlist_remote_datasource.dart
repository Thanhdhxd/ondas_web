import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/data/models/system_playlist_model.dart';

abstract class SystemPlaylistRemoteDataSource {
  Future<PageResultDto<SystemPlaylistModel>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? isActive,
  });

  Future<SystemPlaylistModel> getPlaylist({required String id});

  Future<SystemPlaylistModel> createPlaylist({
    required String name,
    String? description,
    required bool isActive,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<SystemPlaylistModel> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isActive,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<void> deletePlaylist({required String id});

  Future<SystemPlaylistModel> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<SystemPlaylistModel> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<SystemPlaylistModel> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  });
}

