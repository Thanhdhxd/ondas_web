import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

abstract class CreateSongLyricsUseCase {
  Future<Either<Failure, Lyrics>> call(CreateSongLyricsParams params);
}

class CreateSongLyricsParams extends Equatable {
  final String songId;
  final String? language;
  final String? plainText;
  final List<SyncedLyricsLine>? syncedLines;

  const CreateSongLyricsParams({
    required this.songId,
    this.language,
    this.plainText,
    this.syncedLines,
  });

  @override
  List<Object?> get props => [songId, language, plainText, syncedLines];
}
