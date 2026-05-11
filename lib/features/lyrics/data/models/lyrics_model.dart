import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

class SyncedLyricsLineModel extends SyncedLyricsLine {
  const SyncedLyricsLineModel({
    super.id,
    required super.startMs,
    super.endMs,
    required super.lineText,
    required super.lineIndex,
  });

  factory SyncedLyricsLineModel.fromJson(Map<String, dynamic> json) {
    return SyncedLyricsLineModel(
      id: json['id'] as int?,
      startMs: json['startMs'] as int,
      endMs: json['endMs'] as int?,
      lineText: json['lineText'] as String,
      lineIndex: json['lineIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'startMs': startMs,
      if (endMs != null) 'endMs': endMs,
      'lineText': lineText,
      'lineIndex': lineIndex,
    };
  }
}

class LyricsModel extends Lyrics {
  const LyricsModel({
    required super.id,
    required super.songId,
    super.plainText,
    super.hasSynced = false,
    super.language,
    super.createdAt,
    super.updatedAt,
    super.syncedLines = const [],
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    final syncedLinesList = (json['syncedLines'] as List<dynamic>?)
            ?.map((e) =>
                SyncedLyricsLineModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <SyncedLyricsLine>[];

    return LyricsModel(
      id: json['id'] as String,
      songId: json['songId'] as String,
      plainText: json['plainText'] as String?,
      hasSynced: json['hasSynced'] as bool? ?? false,
      language: json['language'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      syncedLines: syncedLinesList,
    );
  }
}
