import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/playlists/domain/entities/playlist_song.dart';

class Playlist extends Equatable {
  final String id;
  final String? userId;
  final String name;
  final String? description;
  final String? coverUrl;
  final bool isPublic;
  final int totalSongs;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PlaylistSong> songs;

  const Playlist({
    required this.id,
    this.userId,
    required this.name,
    this.description,
    this.coverUrl,
    required this.isPublic,
    required this.totalSongs,
    this.createdAt,
    this.updatedAt,
    this.songs = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    coverUrl,
    isPublic,
    totalSongs,
    createdAt,
    updatedAt,
    songs,
  ];
}
