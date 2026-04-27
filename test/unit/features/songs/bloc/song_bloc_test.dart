import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';
import 'package:ondas_web/features/songs/domain/usecases/create_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/delete_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_bloc.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_event.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_state.dart';

class MockGetSongsUseCase extends Mock implements GetSongsUseCase {}

class MockGetSongUseCase extends Mock implements GetSongUseCase {}

class MockCreateSongUseCase extends Mock implements CreateSongUseCase {}

class MockUpdateSongUseCase extends Mock implements UpdateSongUseCase {}

class MockDeleteSongUseCase extends Mock implements DeleteSongUseCase {}

void main() {
  late SongBloc bloc;
  late MockGetSongsUseCase mockGetSongsUseCase;
  late MockGetSongUseCase mockGetSongUseCase;
  late MockCreateSongUseCase mockCreateSongUseCase;
  late MockUpdateSongUseCase mockUpdateSongUseCase;
  late MockDeleteSongUseCase mockDeleteSongUseCase;

  const tSong = SongModel(
    id: 'uuid-1',
    title: 'Noi nay co anh',
    slug: 'noi-nay-co-anh',
    artistNames: ['Son Tung M-TP'],
    genreNames: ['V-Pop'],
    active: true,
  );

  final tPage = PageResultDto<SongModel>(
    items: const [tSong],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  const tCreateParams = CreateSongParams(
    title: 'Noi nay co anh',
    artistIds: ['uuid-artist'],
    genreIds: [1],
    audioBytes: [1, 2, 3],
    audioFileName: 'song.mp3',
  );

  setUpAll(() {
    registerFallbackValue(const GetSongsParams(page: 0, size: 20));
    registerFallbackValue(const GetSongParams(id: 'uuid-1'));
    registerFallbackValue(tCreateParams);
    registerFallbackValue(const UpdateSongParams(id: 'uuid-1'));
    registerFallbackValue(const DeleteSongParams(id: 'uuid-1'));
  });

  setUp(() {
    mockGetSongsUseCase = MockGetSongsUseCase();
    mockGetSongUseCase = MockGetSongUseCase();
    mockCreateSongUseCase = MockCreateSongUseCase();
    mockUpdateSongUseCase = MockUpdateSongUseCase();
    mockDeleteSongUseCase = MockDeleteSongUseCase();
    bloc = SongBloc(
      getSongsUseCase: mockGetSongsUseCase,
      getSongUseCase: mockGetSongUseCase,
      createSongUseCase: mockCreateSongUseCase,
      updateSongUseCase: mockUpdateSongUseCase,
      deleteSongUseCase: mockDeleteSongUseCase,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is SongInitial', () {
    expect(bloc.state, const SongInitial());
  });

  group('SongLoadListEvent', () {
    blocTest<SongBloc, SongState>(
      'emits [SongListLoading, SongListLoaded] when load succeeds',
      build: () {
        when(() => mockGetSongsUseCase(any())).thenAnswer((_) async => Right(tPage));
        return bloc;
      },
      act: (b) => b.add(const SongLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const SongListLoading(),
        SongListLoaded(
          songs: tPage.items,
          page: tPage.page,
          totalPages: tPage.totalPages,
          totalElements: tPage.totalElements,
        ),
      ],
    );

    blocTest<SongBloc, SongState>(
      'emits [SongListLoading, SongListError] when load fails',
      build: () {
        when(() => mockGetSongsUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server error', statusCode: 500),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(const SongLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const SongListLoading(),
        const SongListError(message: 'Server error'),
      ],
    );
  });

  group('SongLoadDetailEvent', () {
    blocTest<SongBloc, SongState>(
      'emits [SongDetailLoading, SongDetailLoaded] when load succeeds',
      build: () {
        when(() => mockGetSongUseCase(any()))
            .thenAnswer((_) async => const Right(tSong));
        return bloc;
      },
      act: (b) => b.add(const SongLoadDetailEvent(id: 'uuid-1')),
      expect: () => [
        const SongDetailLoading(),
        const SongDetailLoaded(song: tSong),
      ],
    );

    blocTest<SongBloc, SongState>(
      'emits [SongDetailLoading, SongOperationError] when load fails',
      build: () {
        when(() => mockGetSongUseCase(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Not found', statusCode: 404)),
        );
        return bloc;
      },
      act: (b) => b.add(const SongLoadDetailEvent(id: 'uuid-1')),
      expect: () => [
        const SongDetailLoading(),
        const SongOperationError(message: 'Not found'),
      ],
    );
  });

  group('SongCreateEvent', () {
    blocTest<SongBloc, SongState>(
      'emits [SongOperationInProgress, SongOperationSuccess] when create succeeds',
      build: () {
        when(() => mockCreateSongUseCase(any()))
            .thenAnswer((_) async => const Right(tSong));
        return bloc;
      },
      act: (b) => b.add(
        const SongCreateEvent(
          title: 'Noi nay co anh',
          artistIds: ['uuid-artist'],
          genreIds: [1],
          audioBytes: [1, 2, 3],
          audioFileName: 'song.mp3',
        ),
      ),
      expect: () => [
        const SongOperationInProgress(),
        const SongOperationSuccess(message: 'Bai hat da duoc tao thanh cong.'),
      ],
    );
  });

  group('SongUpdateEvent', () {
    blocTest<SongBloc, SongState>(
      'emits [SongOperationInProgress, SongOperationSuccess] when update succeeds',
      build: () {
        when(() => mockUpdateSongUseCase(any()))
            .thenAnswer((_) async => const Right(tSong));
        return bloc;
      },
      act: (b) => b.add(const SongUpdateEvent(id: 'uuid-1', title: 'Updated')),
      expect: () => [
        const SongOperationInProgress(),
        const SongOperationSuccess(
          message: 'Bai hat da duoc cap nhat thanh cong.',
        ),
      ],
    );
  });

  group('SongDeleteEvent', () {
    blocTest<SongBloc, SongState>(
      'emits [SongOperationInProgress, SongOperationSuccess] when delete succeeds',
      build: () {
        when(() => mockDeleteSongUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const SongDeleteEvent(id: 'uuid-1')),
      expect: () => [
        const SongOperationInProgress(),
        const SongOperationSuccess(message: 'Bai hat da duoc xoa thanh cong.'),
      ],
    );
  });
}
