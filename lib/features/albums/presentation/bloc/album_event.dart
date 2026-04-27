import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class AlbumLoadListEvent extends AlbumEvent {
  final int page;
  final int size;
  final String? query;

  const AlbumLoadListEvent({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}

class AlbumSearchEvent extends AlbumEvent {
  final String query;

  const AlbumSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class AlbumLoadDetailEvent extends AlbumEvent {
  final String id;

  const AlbumLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AlbumCreateEvent extends AlbumEvent {
  final String title;
  final String? slug;
  final String? releaseDate;
  final String? albumType;
  final String? description;
  final List<String> artistIds;
  final List<int>? coverBytes;
  final String? coverFileName;
  final List<String> songIds; // Songs to add to the album

  const AlbumCreateEvent({
    required this.title,
    this.slug,
    this.releaseDate,
    this.albumType,
    this.description,
    required this.artistIds,
    this.coverBytes,
    this.coverFileName,
    this.songIds = const [],
  });

  @override
  List<Object?> get props => [
        title,
        slug,
        releaseDate,
        albumType,
        description,
        artistIds,
        coverFileName,
        songIds,
      ];
}

class AlbumUpdateEvent extends AlbumEvent {
  final String id;
  final String? title;
  final String? slug;
  final String? releaseDate;
  final String? albumType;
  final String? description;
  final List<String>? artistIds;
  final List<int>? coverBytes;
  final String? coverFileName;
  final List<String>? songIds;         // Songs được chọn sau khi edit
  final List<String> previousSongIds;  // Songs đang có trong album trước khi edit

  const AlbumUpdateEvent({
    required this.id,
    this.title,
    this.slug,
    this.releaseDate,
    this.albumType,
    this.description,
    this.artistIds,
    this.coverBytes,
    this.coverFileName,
    this.songIds,
    this.previousSongIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        releaseDate,
        albumType,
        description,
        artistIds,
        coverFileName,
        songIds,
        previousSongIds,
      ];
}

class AlbumDeleteEvent extends AlbumEvent {
  final String id;

  const AlbumDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
