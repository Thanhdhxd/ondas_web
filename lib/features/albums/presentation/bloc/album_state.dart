import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {
  const AlbumInitial();
}

class AlbumListLoading extends AlbumState {
  const AlbumListLoading();
}

class AlbumListLoaded extends AlbumState {
  final List<Album> albums;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? query;

  const AlbumListLoaded({
    required this.albums,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.query,
  });

  @override
  List<Object?> get props => [albums, page, totalPages, totalElements, query];
}

class AlbumListError extends AlbumState {
  final String message;

  const AlbumListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlbumDetailLoading extends AlbumState {
  const AlbumDetailLoading();
}

class AlbumDetailLoaded extends AlbumState {
  final Album album;

  const AlbumDetailLoaded({required this.album});

  @override
  List<Object?> get props => [album];
}

class AlbumOperationInProgress extends AlbumState {
  const AlbumOperationInProgress();
}

class AlbumOperationSuccess extends AlbumState {
  final String message;

  const AlbumOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlbumOperationError extends AlbumState {
  final String message;

  const AlbumOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
