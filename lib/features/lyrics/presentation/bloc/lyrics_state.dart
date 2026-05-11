import 'package:equatable/equatable.dart';

import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

abstract class LyricsState extends Equatable {
  const LyricsState();

  @override
  List<Object?> get props => [];
}

class LyricsInitial extends LyricsState {
  const LyricsInitial();
}

class LyricsLoading extends LyricsState {
  const LyricsLoading();
}

class LyricsLoaded extends LyricsState {
  final Lyrics lyrics;

  const LyricsLoaded({required this.lyrics});

  @override
  List<Object?> get props => [lyrics];
}

class LyricsNotFound extends LyricsState {
  final String songId;

  const LyricsNotFound({required this.songId});

  @override
  List<Object?> get props => [songId];
}

class LyricsSaving extends LyricsState {
  const LyricsSaving();
}

class LyricsSaved extends LyricsState {
  final Lyrics lyrics;

  const LyricsSaved({required this.lyrics});

  @override
  List<Object?> get props => [lyrics];
}

class LyricsDeleted extends LyricsState {
  final String songId;

  const LyricsDeleted({required this.songId});

  @override
  List<Object?> get props => [songId];
}

class LyricsError extends LyricsState {
  final String message;

  const LyricsError({required this.message});

  @override
  List<Object?> get props => [message];
}
