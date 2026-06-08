import 'package:ondas_web/features/statistics/data/models/admin_stats_model.dart';

abstract class AdminStatsRemoteDataSource {
  Future<List<TopSongModel>> getTopSongs({
    String? from,
    String? to,
    int limit = 10,
  });

  Future<List<TopArtistModel>> getTopArtists({
    String? from,
    String? to,
    int limit = 10,
  });

  Future<List<DailyPlayCountModel>> getPlaysDaily({String? from, String? to});

  Future<DauMauStatsModel> getDauMau({String? date});
}
