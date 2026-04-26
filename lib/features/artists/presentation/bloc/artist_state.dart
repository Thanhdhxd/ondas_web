import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();

  @override
  List<Object?> get props => [];
}

class ArtistInitial extends ArtistState {
  const ArtistInitial();
}

class ArtistListLoading extends ArtistState {
  const ArtistListLoading();
}

class ArtistListLoaded extends ArtistState {
  final List<Artist> artists;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? query;

  const ArtistListLoaded({
    required this.artists,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.query,
  });

  @override
  List<Object?> get props => [artists, page, totalPages, totalElements, query];
}

class ArtistListError extends ArtistState {
  final String message;

  const ArtistListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ArtistDetailLoading extends ArtistState {
  const ArtistDetailLoading();
}

class ArtistDetailLoaded extends ArtistState {
  final Artist artist;

  const ArtistDetailLoaded({required this.artist});

  @override
  List<Object?> get props => [artist];
}

class ArtistOperationInProgress extends ArtistState {
  const ArtistOperationInProgress();
}

class ArtistOperationSuccess extends ArtistState {
  final String message;

  const ArtistOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ArtistOperationError extends ArtistState {
  final String message;

  const ArtistOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
