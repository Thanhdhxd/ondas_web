import 'package:equatable/equatable.dart';

class AlbumTrack extends Equatable {
  final String id;
  final String title;

  const AlbumTrack({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}

class Album extends Equatable {
  final String id;
  final String title;
  final String? slug;
  final String? coverUrl;
  final String? releaseDate;
  final String? albumType;
  final String? description;
  final int totalTracks;
  final List<String> artistIds;
  final List<String> artistNames;
  final List<AlbumTrack> tracklist;

  const Album({
    required this.id,
    required this.title,
    this.slug,
    this.coverUrl,
    this.releaseDate,
    this.albumType,
    this.description,
    this.totalTracks = 0,
    this.artistIds = const [],
    this.artistNames = const [],
    this.tracklist = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        coverUrl,
        releaseDate,
        albumType,
        description,
        totalTracks,
        artistIds,
        artistNames,
        tracklist,
      ];
}
