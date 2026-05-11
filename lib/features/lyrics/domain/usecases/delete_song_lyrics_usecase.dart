import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ondas_web/core/error/failures.dart';

abstract class DeleteSongLyricsUseCase {
  Future<Either<Failure, void>> call(DeleteSongLyricsParams params);
}

class DeleteSongLyricsParams extends Equatable {
  final String songId;

  const DeleteSongLyricsParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}
