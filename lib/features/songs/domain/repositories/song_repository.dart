import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class SongRepository {
  Future<Either<Failure, PageResultDto<Song>>> getSongs({
    required int page,
    required int size,
    String? query,
    String? mode,
  });

  Future<Either<Failure, Song>> getSong({required String id});

  Future<Either<Failure, Song>> createSong({
    required String title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    required List<String> artistIds,
    required List<int> genreIds,
    required List<int> audioBytes,
    required String audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, Song>> updateSong({
    required String id,
    String? title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    List<String>? artistIds,
    List<int>? genreIds,
    bool? active,
    List<int>? audioBytes,
    String? audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, void>> deleteSong({required String id});
}
