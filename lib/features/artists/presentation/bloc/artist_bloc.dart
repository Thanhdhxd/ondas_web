import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/artists/domain/usecases/create_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_event.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final GetArtistsUseCase _getArtistsUseCase;
  final GetArtistUseCase _getArtistUseCase;
  final CreateArtistUseCase _createArtistUseCase;
  final UpdateArtistUseCase _updateArtistUseCase;
  final DeleteArtistUseCase _deleteArtistUseCase;

  ArtistBloc({
    required GetArtistsUseCase getArtistsUseCase,
    required GetArtistUseCase getArtistUseCase,
    required CreateArtistUseCase createArtistUseCase,
    required UpdateArtistUseCase updateArtistUseCase,
    required DeleteArtistUseCase deleteArtistUseCase,
  })  : _getArtistsUseCase = getArtistsUseCase,
        _getArtistUseCase = getArtistUseCase,
        _createArtistUseCase = createArtistUseCase,
        _updateArtistUseCase = updateArtistUseCase,
        _deleteArtistUseCase = deleteArtistUseCase,
        super(const ArtistInitial()) {
    on<ArtistLoadListEvent>(_onLoadList);
    on<ArtistSearchEvent>(_onSearch);
    on<ArtistLoadDetailEvent>(_onLoadDetail);
    on<ArtistCreateEvent>(_onCreate);
    on<ArtistUpdateEvent>(_onUpdate);
    on<ArtistDeleteEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    ArtistLoadListEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistListLoading());
    final result = await _getArtistsUseCase(
      GetArtistsParams(page: event.page, size: event.size, query: event.query),
    );
    result.fold(
      (failure) => emit(ArtistListError(message: failure.message)),
      (page) => emit(ArtistListLoaded(
        artists: page.items,
        page: page.page,
        totalPages: page.totalPages,
        totalElements: page.totalElements,
        query: event.query,
      )),
    );
  }

  Future<void> _onSearch(
    ArtistSearchEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistListLoading());
    final result = await _getArtistsUseCase(
      GetArtistsParams(page: 0, size: 20, query: event.query),
    );
    result.fold(
      (failure) => emit(ArtistListError(message: failure.message)),
      (page) => emit(ArtistListLoaded(
        artists: page.items,
        page: page.page,
        totalPages: page.totalPages,
        totalElements: page.totalElements,
        query: event.query,
      )),
    );
  }

  Future<void> _onLoadDetail(
    ArtistLoadDetailEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistDetailLoading());
    final result = await _getArtistUseCase(GetArtistParams(id: event.id));
    result.fold(
      (failure) => emit(ArtistOperationError(message: failure.message)),
      (artist) => emit(ArtistDetailLoaded(artist: artist)),
    );
  }

  Future<void> _onCreate(
    ArtistCreateEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistOperationInProgress());
    final result = await _createArtistUseCase(
      CreateArtistParams(
        name: event.name,
        slug: event.slug,
        bio: event.bio,
        country: event.country,
        avatarBytes: event.avatarBytes,
        avatarFileName: event.avatarFileName,
      ),
    );
    result.fold(
      (failure) => emit(ArtistOperationError(message: failure.message)),
      (_) => emit(const ArtistOperationSuccess(message: 'Nghệ sĩ đã được tạo thành công.')),
    );
  }

  Future<void> _onUpdate(
    ArtistUpdateEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistOperationInProgress());
    final result = await _updateArtistUseCase(
      UpdateArtistParams(
        id: event.id,
        name: event.name,
        slug: event.slug,
        bio: event.bio,
        country: event.country,
        avatarBytes: event.avatarBytes,
        avatarFileName: event.avatarFileName,
      ),
    );
    result.fold(
      (failure) => emit(ArtistOperationError(message: failure.message)),
      (_) => emit(const ArtistOperationSuccess(message: 'Nghệ sĩ đã được cập nhật thành công.')),
    );
  }

  Future<void> _onDelete(
    ArtistDeleteEvent event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistOperationInProgress());
    final result = await _deleteArtistUseCase(DeleteArtistParams(id: event.id));
    result.fold(
      (failure) => emit(ArtistOperationError(message: failure.message)),
      (_) => emit(const ArtistOperationSuccess(message: 'Nghệ sĩ đã được xóa thành công.')),
    );
  }
}
