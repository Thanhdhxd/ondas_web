import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/tags/domain/repositories/tag_repository.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_event.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository _repository;

  TagBloc({required TagRepository repository})
    : _repository = repository,
      super(const TagInitial()) {
    on<TagLoadListEvent>(_onLoadList);
    on<TagLoadDetailEvent>(_onLoadDetail);
    on<TagCreateEvent>(_onCreate);
    on<TagUpdateEvent>(_onUpdate);
    on<TagDeleteEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    TagLoadListEvent event,
    Emitter<TagState> emit,
  ) async {
    emit(const TagListLoading());
    final result = await _repository.getTags(
      page: event.page,
      size: event.size,
      query: event.query,
      type: event.type,
    );
    result.fold(
      (failure) => emit(TagListError(message: failure.message)),
      (page) => emit(
        TagListLoaded(
          tags: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
          query: event.query,
          type: event.type,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    TagLoadDetailEvent event,
    Emitter<TagState> emit,
  ) async {
    emit(const TagDetailLoading());
    final result = await _repository.getTag(id: event.id);
    result.fold(
      (failure) => emit(TagOperationError(message: failure.message)),
      (tag) => emit(TagDetailLoaded(tag: tag)),
    );
  }

  Future<void> _onCreate(TagCreateEvent event, Emitter<TagState> emit) async {
    emit(const TagOperationInProgress());
    final result = await _repository.createTag(
      name: event.name,
      type: event.type,
      colorHex: event.colorHex,
    );
    result.fold(
      (failure) => emit(TagOperationError(message: failure.message)),
      (_) => emit(const TagOperationSuccess(message: 'Tag da duoc tao.')),
    );
  }

  Future<void> _onUpdate(TagUpdateEvent event, Emitter<TagState> emit) async {
    emit(const TagOperationInProgress());
    final result = await _repository.updateTag(
      id: event.id,
      name: event.name,
      type: event.type,
      colorHex: event.colorHex,
    );
    result.fold(
      (failure) => emit(TagOperationError(message: failure.message)),
      (_) => emit(const TagOperationSuccess(message: 'Tag da duoc cap nhat.')),
    );
  }

  Future<void> _onDelete(TagDeleteEvent event, Emitter<TagState> emit) async {
    emit(const TagOperationInProgress());
    final result = await _repository.deleteTag(id: event.id);
    result.fold(
      (failure) => emit(TagOperationError(message: failure.message)),
      (_) => emit(const TagOperationSuccess(message: 'Tag da duoc xoa.')),
    );
  }
}
