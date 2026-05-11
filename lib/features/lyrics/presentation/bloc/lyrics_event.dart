import 'package:equatable/equatable.dart';

abstract class LyricsEvent extends Equatable {
  const LyricsEvent();

  @override
  List<Object?> get props => [];
}

class LyricsLoadEvent extends LyricsEvent {
  final String songId;

  const LyricsLoadEvent({required this.songId});

  @override
  List<Object?> get props => [songId];
}

class LyricsCreateEvent extends LyricsEvent {
  final String songId;
  final String? language;
  final String? plainText;
  final List<Map<String, dynamic>>? syncedLines;

  const LyricsCreateEvent({
    required this.songId,
    this.language,
    this.plainText,
    this.syncedLines,
  });

  @override
  List<Object?> get props => [songId, language, plainText, syncedLines];
}

class LyricsUpdateEvent extends LyricsEvent {
  final String songId;
  final String? language;
  final String? plainText;
  final List<Map<String, dynamic>>? syncedLines;

  const LyricsUpdateEvent({
    required this.songId,
    this.language,
    this.plainText,
    this.syncedLines,
  });

  @override
  List<Object?> get props => [songId, language, plainText, syncedLines];
}

class LyricsDeleteEvent extends LyricsEvent {
  final String songId;

  const LyricsDeleteEvent({required this.songId});

  @override
  List<Object?> get props => [songId];
}

class LyricsResetEvent extends LyricsEvent {
  const LyricsResetEvent();
}
