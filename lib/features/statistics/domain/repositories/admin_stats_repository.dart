import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';

abstract class AdminStatsRepository {
  Future<Either<Failure, List<TopSong>>> getTopSongs({
    String? from,
    String? to,
    int limit = 10,
  });

  Future<Either<Failure, List<TopArtist>>> getTopArtists({
    String? from,
    String? to,
    int limit = 10,
  });

  Future<Either<Failure, List<DailyPlayCount>>> getPlaysDaily({
    String? from,
    String? to,
  });

  Future<Either<Failure, DauMauStats>> getDauMau({String? date});
}
