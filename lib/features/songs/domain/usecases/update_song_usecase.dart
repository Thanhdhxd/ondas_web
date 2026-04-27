import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class UpdateSongUseCase {
  Future<Either<Failure, Song>> call(UpdateSongParams params);
}

class UpdateSongParams extends Equatable {
  final String id;
  final String? title;
  final String? albumId;
  final int? trackNumber;
  final String? releaseDate;
  final List<String>? artistIds;
  final List<int>? genreIds;
  final bool? active;
  final List<int>? audioBytes;
  final String? audioFileName;
  final List<int>? coverBytes;
  final String? coverFileName;

  const UpdateSongParams({
    required this.id,
    this.title,
    this.albumId,
    this.trackNumber,
    this.releaseDate,
    this.artistIds,
    this.genreIds,
    this.active,
    this.audioBytes,
    this.audioFileName,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    albumId,
    trackNumber,
    releaseDate,
    artistIds,
    genreIds,
    active,
    audioFileName,
    coverFileName,
  ];
}
