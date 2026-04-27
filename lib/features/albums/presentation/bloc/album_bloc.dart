import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/albums/domain/usecases/create_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/delete_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_albums_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/update_album_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase.dart';
import 'package:ondas_web/features/albums/presentation/bloc/album_event.dart';
import 'package:ondas_web/features/albums/presentation/bloc/album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final GetAlbumsUseCase _getAlbumsUseCase;
  final GetAlbumUseCase _getAlbumUseCase;
  final CreateAlbumUseCase _createAlbumUseCase;
  final UpdateAlbumUseCase _updateAlbumUseCase;
  final DeleteAlbumUseCase _deleteAlbumUseCase;
  final UpdateSongUseCase _updateSongUseCase;

  AlbumBloc({
    required GetAlbumsUseCase getAlbumsUseCase,
    required GetAlbumUseCase getAlbumUseCase,
    required CreateAlbumUseCase createAlbumUseCase,
    required UpdateAlbumUseCase updateAlbumUseCase,
    required DeleteAlbumUseCase deleteAlbumUseCase,
    required UpdateSongUseCase updateSongUseCase,
  })  : _getAlbumsUseCase = getAlbumsUseCase,
        _getAlbumUseCase = getAlbumUseCase,
        _createAlbumUseCase = createAlbumUseCase,
        _updateAlbumUseCase = updateAlbumUseCase,
        _deleteAlbumUseCase = deleteAlbumUseCase,
        _updateSongUseCase = updateSongUseCase,
        super(const AlbumInitial()) {
    on<AlbumLoadListEvent>(_onLoadList);
    on<AlbumSearchEvent>(_onSearch);
    on<AlbumLoadDetailEvent>(_onLoadDetail);
    on<AlbumCreateEvent>(_onCreate);
    on<AlbumUpdateEvent>(_onUpdate);
    on<AlbumDeleteEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    AlbumLoadListEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumListLoading());
    final result = await _getAlbumsUseCase(
      GetAlbumsParams(page: event.page, size: event.size, query: event.query),
    );
    result.fold(
      (failure) => emit(AlbumListError(message: failure.message)),
      (page) => emit(AlbumListLoaded(
        albums: page.items,
        page: page.page,
        totalPages: page.totalPages,
        totalElements: page.totalElements,
        query: event.query,
      )),
    );
  }

  Future<void> _onSearch(
    AlbumSearchEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumListLoading());
    final result = await _getAlbumsUseCase(
      GetAlbumsParams(page: 0, size: 20, query: event.query),
    );
    result.fold(
      (failure) => emit(AlbumListError(message: failure.message)),
      (page) => emit(AlbumListLoaded(
        albums: page.items,
        page: page.page,
        totalPages: page.totalPages,
        totalElements: page.totalElements,
        query: event.query,
      )),
    );
  }

  Future<void> _onLoadDetail(
    AlbumLoadDetailEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumDetailLoading());
    final result = await _getAlbumUseCase(GetAlbumParams(id: event.id));
    result.fold(
      (failure) => emit(AlbumOperationError(message: failure.message)),
      (album) => emit(AlbumDetailLoaded(album: album)),
    );
  }

  Future<void> _onCreate(
    AlbumCreateEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumOperationInProgress());
    final result = await _createAlbumUseCase(
      CreateAlbumParams(
        title: event.title,
        slug: event.slug,
        releaseDate: event.releaseDate,
        albumType: event.albumType,
        description: event.description,
        artistIds: event.artistIds,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
      ),
    );
    
    await result.fold(
      (failure) async => emit(AlbumOperationError(message: failure.message)),
      (album) async {
        // After creating album, update songs if any
        if (event.songIds.isNotEmpty) {
          for (final songId in event.songIds) {
            await _updateSongUseCase(UpdateSongParams(
              id: songId,
              albumId: album.id,
            ));
          }
        }
        final hasSongs = event.songIds.isNotEmpty;
        emit(AlbumOperationSuccess(
          message: hasSongs
              ? 'Album đã được tạo thành công và đã cập nhật danh sách bài hát.'
              : 'Album đã được tạo thành công.',
        ));
      },
    );
  }

  Future<void> _onUpdate(
    AlbumUpdateEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumOperationInProgress());
    final result = await _updateAlbumUseCase(
      UpdateAlbumParams(
        id: event.id,
        title: event.title,
        slug: event.slug,
        releaseDate: event.releaseDate,
        albumType: event.albumType,
        description: event.description,
        artistIds: event.artistIds,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
      ),
    );

    await result.fold(
      (failure) async => emit(AlbumOperationError(message: failure.message)),
      (album) async {
        if (event.songIds != null) {
          final newIds = event.songIds!.toSet();
          final prevIds = event.previousSongIds.toSet();

          // Bài hát bị bỏ chọn → xóa albumId
          final removed = prevIds.difference(newIds);
          for (final songId in removed) {
            await _updateSongUseCase(UpdateSongParams(
              id: songId,
              albumId: null, // bỏ liên kết
            ));
          }

          // Bài hát được thêm mới → gắn albumId
          final added = newIds.difference(prevIds);
          for (final songId in added) {
            await _updateSongUseCase(UpdateSongParams(
              id: songId,
              albumId: album.id,
            ));
          }
        }
        emit(const AlbumOperationSuccess(
          message: 'Album đã được cập nhật thành công.',
        ));
      },
    );
  }

  Future<void> _onDelete(
    AlbumDeleteEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(const AlbumOperationInProgress());
    final result = await _deleteAlbumUseCase(DeleteAlbumParams(id: event.id));
    result.fold(
      (failure) => emit(AlbumOperationError(message: failure.message)),
      (_) => emit(const AlbumOperationSuccess(message: 'Album đã được xóa thành công.')),
    );
  }
}
