import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist_song.dart';

class SystemPlaylistModel extends SystemPlaylist {
  const SystemPlaylistModel({
    required super.id,
    required super.name,
    super.description,
    super.coverUrl,
    required super.isActive,
    required super.totalSongs,
    super.createdAt,
    super.updatedAt,
    super.songs,
  });

  factory SystemPlaylistModel.fromJson(Map<String, dynamic> json) {
    final songsJson = json['songs'] as List<dynamic>? ?? const [];
    final songs = songsJson
        .whereType<Map<String, dynamic>>()
        .map(_parsePlaylistSong)
        .whereType<SystemPlaylistSong>()
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    return SystemPlaylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverUrl: json['coverUrl'] as String?,
      // backend may serialize boolean property as `active` (Java bean) or `isActive`;
      // accept both to avoid mismatches
      isActive: json['active'] as bool? ?? json['isActive'] as bool? ?? false,
      totalSongs: json['totalSongs'] as int? ?? songs.length,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      songs: songs,
    );
  }

  static SystemPlaylistSong? _parsePlaylistSong(Map<String, dynamic> json) {
    final song = json['song'] as Map<String, dynamic>?;
    if (song == null) return null;
    final id = song['id']?.toString();
    final title = song['title'] as String?;
    if (id == null || title == null) return null;
    return SystemPlaylistSong(
      position: json['position'] as int? ?? 0,
      id: id,
      title: title,
      coverUrl: song['coverUrl'] as String?,
      durationSeconds: song['durationSeconds'] as int?,
    );
  }
}
