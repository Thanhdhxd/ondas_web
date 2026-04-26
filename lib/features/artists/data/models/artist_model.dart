import 'package:ondas_web/features/artists/domain/entities/artist.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.name,
    super.slug,
    super.bio,
    super.avatarUrl,
    super.country,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      country: json['country'] as String?,
    );
  }
}
