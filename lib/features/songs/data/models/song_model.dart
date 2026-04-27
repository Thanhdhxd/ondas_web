import 'package:ondas_web/features/songs/domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    super.slug,
    super.durationSeconds,
    super.audioUrl,
    super.audioFormat,
    super.audioSizeBytes,
    super.coverUrl,
    super.albumId,
    super.trackNumber,
    super.releaseDate,
    super.playCount,
    super.active,
    super.artistNames,
    super.genreNames,
    super.artistIds,
    super.genreIds,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final artistObjects = (json['artists'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final genreObjects = (json['genres'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    final artistNames = artistObjects
        .map((e) => e['name'] as String?)
        .whereType<String>()
        .toList();
    final artistIds = artistObjects
        .map((e) => e['id']?.toString())
        .whereType<String>()
        .toList();

    final genreNames = genreObjects
        .map((e) => e['name'] as String?)
        .whereType<String>()
        .toList();
    final genreIds = genreObjects
        .map((e) => e['id'])
      .whereType<int>()
        .toList();

    return SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      durationSeconds: json['durationSeconds'] as int?,
      audioUrl: json['audioUrl'] as String?,
      audioFormat: json['audioFormat'] as String?,
      audioSizeBytes: json['audioSizeBytes'] as int?,
      coverUrl: json['coverUrl'] as String?,
      albumId: json['albumId']?.toString(),
      trackNumber: json['trackNumber'] as int?,
      releaseDate: json['releaseDate'] as String?,
      playCount: json['playCount'] as int?,
      active: json['active'] as bool? ?? true,
      artistNames: artistNames,
      genreNames: genreNames,
      artistIds: artistIds,
      genreIds: genreIds,
    );
  }
}
