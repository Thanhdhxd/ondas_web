import 'package:equatable/equatable.dart';

class TopSong extends Equatable {
  final String id;
  final String title;
  final String? coverUrl;
  final int playCount;
  final List<TopSongArtist> artists;

  const TopSong({
    required this.id,
    required this.title,
    this.coverUrl,
    required this.playCount,
    required this.artists,
  });

  @override
  List<Object?> get props => [id, title, coverUrl, playCount, artists];
}

class TopSongArtist extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;

  const TopSongArtist({required this.id, required this.name, this.avatarUrl});

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class TopArtist extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final int playCount;

  const TopArtist({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.playCount,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, playCount];
}

class DailyPlayCount extends Equatable {
  final String date;
  final int playCount;

  const DailyPlayCount({required this.date, required this.playCount});

  @override
  List<Object?> get props => [date, playCount];
}

class DauMauStats extends Equatable {
  final String date;
  final int dau;
  final int mau;
  final int mauWindowDays;

  const DauMauStats({
    required this.date,
    required this.dau,
    required this.mau,
    required this.mauWindowDays,
  });

  @override
  List<Object?> get props => [date, dau, mau, mauWindowDays];
}
