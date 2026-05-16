import 'package:equatable/equatable.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class PlaylistLoadListEvent extends PlaylistEvent {
  final int page;
  final int size;
  final String? query;
  final bool? owner;
  final bool? isPublic;

  const PlaylistLoadListEvent({
    required this.page,
    required this.size,
    this.query,
    this.owner,
    this.isPublic,
  });

  @override
  List<Object?> get props => [page, size, query, owner, isPublic];
}

class PlaylistLoadDetailEvent extends PlaylistEvent {
  final String id;

  const PlaylistLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class PlaylistCreateEvent extends PlaylistEvent {
  final String name;
  final String? description;
  final bool isPublic;
  final List<int>? coverBytes;
  final String? coverFileName;

  const PlaylistCreateEvent({
    required this.name,
    this.description,
    required this.isPublic,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [name, description, isPublic, coverFileName];
}

class PlaylistUpdateEvent extends PlaylistEvent {
  final String id;
  final String name;
  final String? description;
  final bool isPublic;
  final List<int>? coverBytes;
  final String? coverFileName;

  const PlaylistUpdateEvent({
    required this.id,
    required this.name,
    this.description,
    required this.isPublic,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [id, name, description, isPublic, coverFileName];
}

class PlaylistDeleteEvent extends PlaylistEvent {
  final String id;

  const PlaylistDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class PlaylistAddSongEvent extends PlaylistEvent {
  final String playlistId;
  final String songId;

  const PlaylistAddSongEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

class PlaylistRemoveSongEvent extends PlaylistEvent {
  final String playlistId;
  final String songId;

  const PlaylistRemoveSongEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

class PlaylistReorderSongsEvent extends PlaylistEvent {
  final String playlistId;
  final List<String> songIds;

  const PlaylistReorderSongsEvent({
    required this.playlistId,
    required this.songIds,
  });

  @override
  List<Object?> get props => [playlistId, songIds];
}
