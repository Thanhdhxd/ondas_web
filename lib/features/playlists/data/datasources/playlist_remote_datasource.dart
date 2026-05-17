import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/playlists/data/models/playlist_model.dart';

abstract class PlaylistRemoteDataSource {
  Future<PageResultDto<PlaylistModel>> getPlaylists({
    required int page,
    required int size,
    String? query,
    bool? owner,
    bool? isPublic,
  });

  Future<PlaylistModel> getPlaylist({required String id});

  Future<PlaylistModel> createPlaylist({
    required String name,
    String? description,
    required bool isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<PlaylistModel> updatePlaylist({
    required String id,
    String? name,
    String? description,
    bool? isPublic,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<void> deletePlaylist({required String id});

  Future<PlaylistModel> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<PlaylistModel> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<PlaylistModel> reorderPlaylistSongs({
    required String playlistId,
    required List<String> songIds,
  });
}
