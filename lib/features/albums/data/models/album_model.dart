import 'package:ondas_web/features/albums/domain/entities/album.dart';

class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.title,
    super.slug,
    super.coverUrl,
    super.releaseDate,
    super.albumType,
    super.description,
    super.totalTracks,
    super.artistIds,
    super.artistNames,
    super.tracklist,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final artistIds = (json['artistIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    final artistObjects = (json['artists'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    final artistNames = artistObjects
        .map((e) => e['name'] as String?)
        .whereType<String>()
        .toList();

    final tracks = (json['tracklist'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(
              (item) => AlbumTrack(
                id: item['id']?.toString() ?? '',
                title: (item['title'] as String?) ?? 'Unknown',
              ),
            )
            .where((item) => item.id.isNotEmpty)
            .toList() ??
        const <AlbumTrack>[];

    return AlbumModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      coverUrl: json['coverUrl'] as String?,
      releaseDate: json['releaseDate'] as String?,
      albumType: json['albumType'] as String?,
      description: json['description'] as String?,
      totalTracks: (json['totalTracks'] as int?) ?? tracks.length,
      artistIds: artistIds,
      artistNames: artistNames,
      tracklist: tracks,
    );
  }
}
