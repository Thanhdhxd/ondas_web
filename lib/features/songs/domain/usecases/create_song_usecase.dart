import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class CreateSongUseCase {
  Future<Either<Failure, Song>> call(CreateSongParams params);
}

class CreateSongParams extends Equatable {
  final String title;
  final String? albumId;
  final int? trackNumber;
  final String? releaseDate;
  final List<String> artistIds;
  final List<int> genreIds;
  final List<int> audioBytes;
  final String audioFileName;
  final List<int>? coverBytes;
  final String? coverFileName;

  const CreateSongParams({
    required this.title,
    this.albumId,
    this.trackNumber,
    this.releaseDate,
    required this.artistIds,
    required this.genreIds,
    required this.audioBytes,
    required this.audioFileName,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
    title,
    albumId,
    trackNumber,
    releaseDate,
    artistIds,
    genreIds,
    audioBytes,
    audioFileName,
    coverFileName,
  ];
}
