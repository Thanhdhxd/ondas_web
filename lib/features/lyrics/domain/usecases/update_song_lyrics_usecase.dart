import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

abstract class UpdateSongLyricsUseCase {
  Future<Either<Failure, Lyrics>> call(UpdateSongLyricsParams params);
}

class UpdateSongLyricsParams extends Equatable {
  final String songId;
  final String? language;
  final String? plainText;
  final List<SyncedLyricsLine>? syncedLines;

  const UpdateSongLyricsParams({
    required this.songId,
    this.language,
    this.plainText,
    this.syncedLines,
  });

  @override
  List<Object?> get props => [songId, language, plainText, syncedLines];
}
