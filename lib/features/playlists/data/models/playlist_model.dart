import 'package:ondas_web/features/playlists/domain/entities/playlist.dart';
import 'package:ondas_web/features/playlists/domain/entities/playlist_song.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    required super.id,
    super.userId,
    required super.name,
    super.description,
    super.coverUrl,
    required super.isPublic,
    required super.totalSongs,
    super.createdAt,
    super.updatedAt,
    super.songs,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final songsJson = json['songs'] as List<dynamic>? ?? const [];
    final songs = songsJson
        .whereType<Map<String, dynamic>>()
        .map(_parsePlaylistSong)
        .whereType<PlaylistSong>()
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    return PlaylistModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverUrl: json['coverUrl'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      totalSongs: json['totalSongs'] as int? ?? songs.length,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      songs: songs,
    );
  }

  static PlaylistSong? _parsePlaylistSong(Map<String, dynamic> json) {
    final song = json['song'] as Map<String, dynamic>?;
    if (song == null) return null;
    final id = song['id']?.toString();
    final title = song['title'] as String?;
    if (id == null || title == null) return null;
    return PlaylistSong(
      position: json['position'] as int? ?? 0,
      id: id,
      title: title,
      coverUrl: song['coverUrl'] as String?,
      durationSeconds: song['durationSeconds'] as int?,
    );
  }
}
