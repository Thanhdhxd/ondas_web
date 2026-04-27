import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object?> get props => [];
}

class SongInitial extends SongState {
  const SongInitial();
}

class SongListLoading extends SongState {
  const SongListLoading();
}

class SongListLoaded extends SongState {
  final List<Song> songs;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? query;

  const SongListLoaded({
    required this.songs,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.query,
  });

  @override
  List<Object?> get props => [songs, page, totalPages, totalElements, query];
}

class SongListError extends SongState {
  final String message;

  const SongListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SongDetailLoading extends SongState {
  const SongDetailLoading();
}

class SongDetailLoaded extends SongState {
  final Song song;

  const SongDetailLoaded({required this.song});

  @override
  List<Object?> get props => [song];
}

class SongOperationInProgress extends SongState {
  const SongOperationInProgress();
}

class SongOperationSuccess extends SongState {
  final String message;

  const SongOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SongOperationError extends SongState {
  final String message;

  const SongOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
