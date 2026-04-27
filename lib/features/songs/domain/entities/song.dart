import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String? slug;
  final int? durationSeconds;
  final String? audioUrl;
  final String? audioFormat;
  final int? audioSizeBytes;
  final String? coverUrl;
  final String? albumId;
  final int? trackNumber;
  final String? releaseDate;
  final int? playCount;
  final bool active;
  final List<String> artistNames;
  final List<String> genreNames;
  final List<String> artistIds;
  final List<int> genreIds;

  const Song({
    required this.id,
    required this.title,
    this.slug,
    this.durationSeconds,
    this.audioUrl,
    this.audioFormat,
    this.audioSizeBytes,
    this.coverUrl,
    this.albumId,
    this.trackNumber,
    this.releaseDate,
    this.playCount,
    this.active = true,
    this.artistNames = const [],
    this.genreNames = const [],
    this.artistIds = const [],
    this.genreIds = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    durationSeconds,
    audioUrl,
    audioFormat,
    audioSizeBytes,
    coverUrl,
    albumId,
    trackNumber,
    releaseDate,
    playCount,
    active,
    artistNames,
    genreNames,
    artistIds,
    genreIds,
  ];
}
