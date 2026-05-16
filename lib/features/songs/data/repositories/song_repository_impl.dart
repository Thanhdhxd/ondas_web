import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/data/datasources/song_remote_datasource.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource _dataSource;

  const SongRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PageResultDto<Song>>> getSongs({
    required int page,
    required int size,
    String? query,
    String? mode,
  }) async {
    try {
      final result = await _dataSource.getSongs(
        page: page,
        size: size,
        query: query,
        mode: mode,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Song>> getSong({required String id}) async {
    try {
      final result = await _dataSource.getSong(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
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
    String? lyrics,
  }) async {
    try {
      final result = await _dataSource.createSong(
        title: title,
        albumId: albumId,
        trackNumber: trackNumber,
        releaseDate: releaseDate,
        artistIds: artistIds,
        genreIds: genreIds,
        audioBytes: audioBytes,
        audioFileName: audioFileName,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
        lyrics: lyrics,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
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
  }) async {
    try {
      final result = await _dataSource.updateSong(
        id: id,
        title: title,
        albumId: albumId,
        trackNumber: trackNumber,
        releaseDate: releaseDate,
        artistIds: artistIds,
        genreIds: genreIds,
        active: active,
        audioBytes: audioBytes,
        audioFileName: audioFileName,
        coverBytes: coverBytes,
        coverFileName: coverFileName,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSong({required String id}) async {
    try {
      await _dataSource.deleteSong(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getSongTags({required String songId}) async {
    try {
      final result = await _dataSource.getSongTags(songId: songId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> replaceSongTags({
    required String songId,
    required List<int> tagIds,
  }) async {
    try {
      final result = await _dataSource.replaceSongTags(
        songId: songId,
        tagIds: tagIds,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
