import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/exceptions.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/statistics/data/datasources/admin_stats_remote_datasource.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';
import 'package:ondas_web/features/statistics/domain/repositories/admin_stats_repository.dart';

class AdminStatsRepositoryImpl implements AdminStatsRepository {
  final AdminStatsRemoteDataSource _dataSource;

  const AdminStatsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TopSong>>> getTopSongs({
    String? from,
    String? to,
    int limit = 10,
  }) async {
    try {
      final result = await _dataSource.getTopSongs(
        from: from,
        to: to,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<TopArtist>>> getTopArtists({
    String? from,
    String? to,
    int limit = 10,
  }) async {
    try {
      final result = await _dataSource.getTopArtists(
        from: from,
        to: to,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<DailyPlayCount>>> getPlaysDaily({
    String? from,
    String? to,
  }) async {
    try {
      final result = await _dataSource.getPlaysDaily(from: from, to: to);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, DauMauStats>> getDauMau({String? date}) async {
    try {
      final result = await _dataSource.getDauMau(date: date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
