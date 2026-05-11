import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';

abstract class GetSongLyricsUseCase {
  Future<Either<Failure, Lyrics>> call(GetSongLyricsParams params);
}

class GetSongLyricsParams extends Equatable {
  final String songId;

  const GetSongLyricsParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}
