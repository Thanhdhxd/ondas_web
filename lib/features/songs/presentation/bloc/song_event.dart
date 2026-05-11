import 'package:equatable/equatable.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object?> get props => [];
}

class SongLoadListEvent extends SongEvent {
  final int page;
  final int size;
  final String? query;

  const SongLoadListEvent({
    required this.page,
    required this.size,
    this.query,
  });

  @override
  List<Object?> get props => [page, size, query];
}

class SongLoadDetailEvent extends SongEvent {
  final String id;

  const SongLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SongCreateEvent extends SongEvent {
  final String title;
  final String? albumId;
  final int? trackNumber;
  final String? releaseDate;
  final List<String> artistIds;
  final List<int> genreIds;
  final List<int> audioBytes;
  final String audioFileName;
  final List<int>? coverBytes;
  final String? coverFileName;
  final String? lyrics;

  const SongCreateEvent({
    required this.title,
    this.albumId,
    this.trackNumber,
    this.releaseDate,
    required this.artistIds,
    required this.genreIds,
    required this.audioBytes,
    required this.audioFileName,
    this.coverBytes,
    this.coverFileName,
    this.lyrics,
  });

  @override
  List<Object?> get props => [
    title,
    albumId,
    trackNumber,
    releaseDate,
    artistIds,
    genreIds,
    audioFileName,
    coverFileName,
  ];
}

class SongUpdateEvent extends SongEvent {
  final String id;
  final String? title;
  final String? albumId;
  final int? trackNumber;
  final String? releaseDate;
  final List<String>? artistIds;
  final List<int>? genreIds;
  final bool? active;
  final List<int>? audioBytes;
  final String? audioFileName;
  final List<int>? coverBytes;
  final String? coverFileName;

  const SongUpdateEvent({
    required this.id,
    this.title,
    this.albumId,
    this.trackNumber,
    this.releaseDate,
    this.artistIds,
    this.genreIds,
    this.active,
    this.audioBytes,
    this.audioFileName,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    albumId,
    trackNumber,
    releaseDate,
    artistIds,
    genreIds,
    active,
    audioFileName,
    coverFileName,
  ];
}

class SongDeleteEvent extends SongEvent {
  final String id;

  const SongDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
