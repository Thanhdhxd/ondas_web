import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

abstract class TagState extends Equatable {
  const TagState();

  @override
  List<Object?> get props => [];
}

class TagInitial extends TagState {
  const TagInitial();
}

class TagListLoading extends TagState {
  const TagListLoading();
}

class TagListLoaded extends TagState {
  final List<Tag> tags;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? query;
  final String? type;

  const TagListLoaded({
    required this.tags,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.query,
    this.type,
  });

  @override
  List<Object?> get props => [
    tags,
    page,
    totalPages,
    totalElements,
    query,
    type,
  ];
}

class TagListError extends TagState {
  final String message;

  const TagListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TagDetailLoading extends TagState {
  const TagDetailLoading();
}

class TagDetailLoaded extends TagState {
  final Tag tag;

  const TagDetailLoaded({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class TagOperationInProgress extends TagState {
  const TagOperationInProgress();
}

class TagOperationSuccess extends TagState {
  final String message;

  const TagOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TagOperationError extends TagState {
  final String message;

  const TagOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
