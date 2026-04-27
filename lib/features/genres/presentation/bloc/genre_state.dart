import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {
  const GenreInitial();
}

class GenreListLoading extends GenreState {
  const GenreListLoading();
}

class GenreListLoaded extends GenreState {
  final List<Genre> genres;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? query;

  const GenreListLoaded({
    required this.genres,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.query,
  });

  @override
  List<Object?> get props => [genres, page, totalPages, totalElements, query];
}

class GenreListError extends GenreState {
  final String message;

  const GenreListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GenreDetailLoading extends GenreState {
  const GenreDetailLoading();
}

class GenreDetailLoaded extends GenreState {
  final Genre genre;

  const GenreDetailLoaded({required this.genre});

  @override
  List<Object?> get props => [genre];
}

class GenreOperationInProgress extends GenreState {
  const GenreOperationInProgress();
}

class GenreOperationSuccess extends GenreState {
  final String message;

  const GenreOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GenreOperationError extends GenreState {
  final String message;

  const GenreOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
