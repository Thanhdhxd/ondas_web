import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object?> get props => [];
}

class GenreLoadListEvent extends GenreEvent {
  final int page;
  final int size;
  final String? query;

  const GenreLoadListEvent({
    required this.page,
    required this.size,
    this.query,
  });

  @override
  List<Object?> get props => [page, size, query];
}

class GenreSearchEvent extends GenreEvent {
  final String query;

  const GenreSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GenreLoadDetailEvent extends GenreEvent {
  final int id;

  const GenreLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GenreCreateEvent extends GenreEvent {
  final String name;
  final String? slug;
  final String? description;
  final String? coverUrl;
  final List<int>? coverBytes;
  final String? coverFileName;

  const GenreCreateEvent({
    required this.name,
    this.slug,
    this.description,
    this.coverUrl,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [name, slug, description, coverUrl, coverFileName];
}

class GenreUpdateEvent extends GenreEvent {
  final int id;
  final String? name;
  final String? slug;
  final String? description;
  final String? coverUrl;
  final List<int>? coverBytes;
  final String? coverFileName;

  const GenreUpdateEvent({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.coverUrl,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    coverUrl,
    coverFileName,
  ];
}

class GenreDeleteEvent extends GenreEvent {
  final int id;

  const GenreDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
