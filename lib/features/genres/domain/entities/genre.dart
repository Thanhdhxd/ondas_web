import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? coverUrl;

  const Genre({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.coverUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, description, coverUrl];
}
