import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/genres/domain/usecases/create_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/delete_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/update_genre_usecase.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_event.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final GetGenresUseCase _getGenresUseCase;
  final GetGenreUseCase _getGenreUseCase;
  final CreateGenreUseCase _createGenreUseCase;
  final UpdateGenreUseCase _updateGenreUseCase;
  final DeleteGenreUseCase _deleteGenreUseCase;

  GenreBloc({
    required GetGenresUseCase getGenresUseCase,
    required GetGenreUseCase getGenreUseCase,
    required CreateGenreUseCase createGenreUseCase,
    required UpdateGenreUseCase updateGenreUseCase,
    required DeleteGenreUseCase deleteGenreUseCase,
  }) : _getGenresUseCase = getGenresUseCase,
       _getGenreUseCase = getGenreUseCase,
       _createGenreUseCase = createGenreUseCase,
       _updateGenreUseCase = updateGenreUseCase,
       _deleteGenreUseCase = deleteGenreUseCase,
       super(const GenreInitial()) {
    on<GenreLoadListEvent>(_onLoadList);
    on<GenreSearchEvent>(_onSearch);
    on<GenreLoadDetailEvent>(_onLoadDetail);
    on<GenreCreateEvent>(_onCreate);
    on<GenreUpdateEvent>(_onUpdate);
    on<GenreDeleteEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    GenreLoadListEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreListLoading());
    final result = await _getGenresUseCase(
      GetGenresParams(page: event.page, size: event.size, query: event.query),
    );
    result.fold(
      (failure) => emit(GenreListError(message: failure.message)),
      (page) => emit(
        GenreListLoaded(
          genres: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onSearch(
    GenreSearchEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreListLoading());
    final result = await _getGenresUseCase(
      GetGenresParams(page: 0, size: 20, query: event.query),
    );
    result.fold(
      (failure) => emit(GenreListError(message: failure.message)),
      (page) => emit(
        GenreListLoaded(
          genres: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    GenreLoadDetailEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreDetailLoading());
    final result = await _getGenreUseCase(GetGenreParams(id: event.id));
    result.fold(
      (failure) => emit(GenreOperationError(message: failure.message)),
      (genre) => emit(GenreDetailLoaded(genre: genre)),
    );
  }

  Future<void> _onCreate(
    GenreCreateEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreOperationInProgress());
    final result = await _createGenreUseCase(
      CreateGenreParams(
        name: event.name,
        slug: event.slug,
        description: event.description,
        coverUrl: event.coverUrl,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
      ),
    );
    result.fold(
      (failure) => emit(GenreOperationError(message: failure.message)),
      (_) => emit(
        const GenreOperationSuccess(
          message: 'Thể loại đã được tạo thành công.',
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    GenreUpdateEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreOperationInProgress());
    final result = await _updateGenreUseCase(
      UpdateGenreParams(
        id: event.id,
        name: event.name,
        slug: event.slug,
        description: event.description,
        coverUrl: event.coverUrl,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
      ),
    );
    result.fold(
      (failure) => emit(GenreOperationError(message: failure.message)),
      (_) => emit(
        const GenreOperationSuccess(
          message: 'Thể loại đã được cập nhật thành công.',
        ),
      ),
    );
  }

  Future<void> _onDelete(
    GenreDeleteEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreOperationInProgress());
    final result = await _deleteGenreUseCase(DeleteGenreParams(id: event.id));
    result.fold(
      (failure) => emit(GenreOperationError(message: failure.message)),
      (_) => emit(
        const GenreOperationSuccess(
          message: 'Thể loại đã được xóa thành công.',
        ),
      ),
    );
  }
}
