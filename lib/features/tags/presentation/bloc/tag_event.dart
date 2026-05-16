import 'package:equatable/equatable.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object?> get props => [];
}

class TagLoadListEvent extends TagEvent {
  final int page;
  final int size;
  final String? query;
  final String? type;

  const TagLoadListEvent({
    required this.page,
    required this.size,
    this.query,
    this.type,
  });

  @override
  List<Object?> get props => [page, size, query, type];
}

class TagLoadDetailEvent extends TagEvent {
  final int id;

  const TagLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class TagCreateEvent extends TagEvent {
  final String name;
  final String? type;
  final String? colorHex;

  const TagCreateEvent({required this.name, this.type, this.colorHex});

  @override
  List<Object?> get props => [name, type, colorHex];
}

class TagUpdateEvent extends TagEvent {
  final int id;
  final String name;
  final String? type;
  final String? colorHex;

  const TagUpdateEvent({
    required this.id,
    required this.name,
    this.type,
    this.colorHex,
  });

  @override
  List<Object?> get props => [id, name, type, colorHex];
}

class TagDeleteEvent extends TagEvent {
  final int id;

  const TagDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
