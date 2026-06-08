import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';

class TopSongModel extends TopSong {
  const TopSongModel({
    required super.id,
    required super.title,
    super.coverUrl,
    required super.playCount,
    required super.artists,
  });

  factory TopSongModel.fromJson(Map<String, dynamic> json) {
    final rawArtists = json['artists'] as List<dynamic>? ?? [];
    return TopSongModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      coverUrl: json['coverUrl'] as String?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      artists: rawArtists
          .map(
            (a) => TopSongArtist(
              id: a['id'] as String? ?? '',
              name: a['name'] as String? ?? '',
              avatarUrl: a['avatarUrl'] as String?,
            ),
          )
          .toList(),
    );
  }
}

class TopArtistModel extends TopArtist {
  const TopArtistModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    required super.playCount,
  });

  factory TopArtistModel.fromJson(Map<String, dynamic> json) {
    return TopArtistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyPlayCountModel extends DailyPlayCount {
  const DailyPlayCountModel({required super.date, required super.playCount});

  factory DailyPlayCountModel.fromJson(Map<String, dynamic> json) {
    return DailyPlayCountModel(
      date: json['date'] as String? ?? '',
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class DauMauStatsModel extends DauMauStats {
  const DauMauStatsModel({
    required super.date,
    required super.dau,
    required super.mau,
    required super.mauWindowDays,
  });

  factory DauMauStatsModel.fromJson(Map<String, dynamic> json) {
    return DauMauStatsModel(
      date: json['date'] as String? ?? '',
      dau: (json['dau'] as num?)?.toInt() ?? 0,
      mau: (json['mau'] as num?)?.toInt() ?? 0,
      mauWindowDays: (json['mauWindowDays'] as num?)?.toInt() ?? 30,
    );
  }
}
