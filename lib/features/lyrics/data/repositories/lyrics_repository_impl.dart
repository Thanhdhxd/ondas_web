import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/data/datasources/lyrics_remote_datasource.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';
import 'package:ondas_web/features/lyrics/domain/repositories/lyrics_repository.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsRemoteDataSource _dataSource;

  const LyricsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Lyrics>> getLyrics({required String songId}) async {
    try {
      final result = await _dataSource.getLyrics(songId: songId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Lyrics>> createLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<SyncedLyricsLine>? syncedLines,
  }) async {
    try {
      final result = await _dataSource.createLyrics(
        songId: songId,
        language: language,
        plainText: plainText,
        syncedLines: syncedLines
            ?.map((e) => {
                  'startMs': e.startMs,
                  if (e.endMs != null) 'endMs': e.endMs,
                  'lineText': e.lineText,
                  'lineIndex': e.lineIndex,
                })
            .toList(),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Lyrics>> updateLyrics({
    required String songId,
    String? language,
    String? plainText,
    List<SyncedLyricsLine>? syncedLines,
  }) async {
    try {
      final result = await _dataSource.updateLyrics(
        songId: songId,
        language: language,
        plainText: plainText,
        syncedLines: syncedLines
            ?.map((e) => {
                  'startMs': e.startMs,
                  if (e.endMs != null) 'endMs': e.endMs,
                  'lineText': e.lineText,
                  'lineIndex': e.lineIndex,
                })
            .toList(),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLyrics({required String songId}) async {
    try {
      await _dataSource.deleteLyrics(songId: songId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
