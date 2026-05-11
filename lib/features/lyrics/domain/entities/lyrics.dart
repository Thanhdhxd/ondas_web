import 'package:equatable/equatable.dart';

class SyncedLyricsLine extends Equatable {
  final int? id;
  final int startMs;
  final int? endMs;
  final String lineText;
  final int lineIndex;

  const SyncedLyricsLine({
    this.id,
    required this.startMs,
    this.endMs,
    required this.lineText,
    required this.lineIndex,
  });

  @override
  List<Object?> get props => [id, startMs, endMs, lineText, lineIndex];
}

class Lyrics extends Equatable {
  final String id;
  final String songId;
  final String? plainText;
  final bool hasSynced;
  final String? language;
  final String? createdAt;
  final String? updatedAt;
  final List<SyncedLyricsLine> syncedLines;

  const Lyrics({
    required this.id,
    required this.songId,
    this.plainText,
    this.hasSynced = false,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.syncedLines = const [],
  });

  @override
  List<Object?> get props => [
        id,
        songId,
        plainText,
        hasSynced,
        language,
        createdAt,
        updatedAt,
        syncedLines,
      ];
}
