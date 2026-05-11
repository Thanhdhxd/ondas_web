import 'package:ondas_web/features/lyrics/data/models/lyrics_model.dart';

abstract class LyricsRemoteDataSource {
  Future<LyricsModel> getLyrics({required String songId});

  Future<LyricsModel> createLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<Map<String, dynamic>>? syncedLines,
  });

  Future<LyricsModel> updateLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<Map<String, dynamic>>? syncedLines,
  });

  Future<void> deleteLyrics({required String songId});
}
