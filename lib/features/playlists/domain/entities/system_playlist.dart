import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist_song.dart';

class SystemPlaylist extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final bool isActive;
  final int totalSongs;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SystemPlaylistSong> songs;

  const SystemPlaylist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.isActive,
    required this.totalSongs,
    this.createdAt,
    this.updatedAt,
    this.songs = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    coverUrl,
    isActive,
    totalSongs,
    createdAt,
    updatedAt,
    songs,
  ];
}
