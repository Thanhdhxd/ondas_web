import 'package:ondas_web/features/genres/domain/entities/genre.dart';

class GenreModel extends Genre {
  const GenreModel({
    required super.id,
    required super.name,
    super.slug,
    super.description,
    super.coverUrl,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      coverUrl: json['coverUrl'] as String?,
    );
  }
}
