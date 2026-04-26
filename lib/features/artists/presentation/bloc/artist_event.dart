import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}

class ArtistLoadListEvent extends ArtistEvent {
  final int page;
  final int size;
  final String? query;

  const ArtistLoadListEvent({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}

class ArtistSearchEvent extends ArtistEvent {
  final String query;

  const ArtistSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ArtistLoadDetailEvent extends ArtistEvent {
  final String id;

  const ArtistLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ArtistCreateEvent extends ArtistEvent {
  final String name;
  final String? slug;
  final String? bio;
  final String? country;
  final List<int>? avatarBytes;
  final String? avatarFileName;

  const ArtistCreateEvent({
    required this.name,
    this.slug,
    this.bio,
    this.country,
    this.avatarBytes,
    this.avatarFileName,
  });

  @override
  List<Object?> get props => [name, slug, bio, country, avatarFileName];
}

class ArtistUpdateEvent extends ArtistEvent {
  final String id;
  final String? name;
  final String? slug;
  final String? bio;
  final String? country;
  final List<int>? avatarBytes;
  final String? avatarFileName;

  const ArtistUpdateEvent({
    required this.id,
    this.name,
    this.slug,
    this.bio,
    this.country,
    this.avatarBytes,
    this.avatarFileName,
  });

  @override
  List<Object?> get props => [id, name, slug, bio, country, avatarFileName];
}

class ArtistDeleteEvent extends ArtistEvent {
  final String id;

  const ArtistDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
