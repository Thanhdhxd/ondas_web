import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

abstract class LyricsRepository {
  Future<Either<Failure, Lyrics>> getLyrics({required String songId});

  Future<Either<Failure, Lyrics>> createLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<SyncedLyricsLine>? syncedLines,
  });

  Future<Either<Failure, Lyrics>> updateLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<SyncedLyricsLine>? syncedLines,
  });

  Future<Either<Failure, void>> deleteLyrics({required String songId});
}
