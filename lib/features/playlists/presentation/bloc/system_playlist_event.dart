import 'package:equatable/equatable.dart';

abstract class SystemPlaylistEvent extends Equatable {
  const SystemPlaylistEvent();

  @override
  List<Object?> get props => [];
}

class SystemPlaylistLoadListEvent extends SystemPlaylistEvent {
  final int page;
  final int size;
  final String? query;
  final bool? isActive;

  const SystemPlaylistLoadListEvent({
    required this.page,
    required this.size,
    this.query,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, size, query, isActive];
}

class SystemPlaylistLoadDetailEvent extends SystemPlaylistEvent {
  final String id;

  const SystemPlaylistLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SystemPlaylistCreateEvent extends SystemPlaylistEvent {
  final String name;
  final String? description;
  final bool isActive;
  final List<int>? coverBytes;
  final String? coverFileName;

  const SystemPlaylistCreateEvent({
    required this.name,
    this.description,
    required this.isActive,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [name, description, isActive, coverFileName];
}

class SystemPlaylistUpdateEvent extends SystemPlaylistEvent {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final List<int>? coverBytes;
  final String? coverFileName;

  const SystemPlaylistUpdateEvent({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [id, name, description, isActive, coverFileName];
}

class SystemPlaylistDeleteEvent extends SystemPlaylistEvent {
  final String id;

  const SystemPlaylistDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SystemPlaylistAddSongEvent extends SystemPlaylistEvent {
  final String playlistId;
  final String songId;

  const SystemPlaylistAddSongEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

class SystemPlaylistRemoveSongEvent extends SystemPlaylistEvent {
  final String playlistId;
  final String songId;

  const SystemPlaylistRemoveSongEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

class SystemPlaylistReorderSongsEvent extends SystemPlaylistEvent {
  final String playlistId;
  final List<String> songIds;

  const SystemPlaylistReorderSongsEvent({
    required this.playlistId,
    required this.songIds,
  });

  @override
  List<Object?> get props => [playlistId, songIds];
}
