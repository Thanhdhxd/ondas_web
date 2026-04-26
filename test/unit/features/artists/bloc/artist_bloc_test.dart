import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/data/models/artist_model.dart';
import 'package:ondas_web/features/artists/domain/usecases/create_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_bloc.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_event.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_state.dart';

class MockGetArtistsUseCase extends Mock implements GetArtistsUseCase {}

class MockGetArtistUseCase extends Mock implements GetArtistUseCase {}

class MockCreateArtistUseCase extends Mock implements CreateArtistUseCase {}

class MockUpdateArtistUseCase extends Mock implements UpdateArtistUseCase {}

class MockDeleteArtistUseCase extends Mock implements DeleteArtistUseCase {}

void main() {
  late ArtistBloc bloc;
  late MockGetArtistsUseCase mockGetArtistsUseCase;
  late MockGetArtistUseCase mockGetArtistUseCase;
  late MockCreateArtistUseCase mockCreateArtistUseCase;
  late MockUpdateArtistUseCase mockUpdateArtistUseCase;
  late MockDeleteArtistUseCase mockDeleteArtistUseCase;

  const tArtist = ArtistModel(
    id: 'uuid-1',
    name: 'Sơn Tùng M-TP',
    slug: 'son-tung-m-tp',
    country: 'Vietnam',
  );

  final tPage = PageResultDto<ArtistModel>(
    items: [tArtist],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  setUpAll(() {
    registerFallbackValue(const GetArtistsParams(page: 0, size: 20));
    registerFallbackValue(const GetArtistParams(id: 'uuid-1'));
    registerFallbackValue(const CreateArtistParams(name: 'Test'));
    registerFallbackValue(const UpdateArtistParams(id: 'uuid-1'));
    registerFallbackValue(const DeleteArtistParams(id: 'uuid-1'));
  });

  setUp(() {
    mockGetArtistsUseCase = MockGetArtistsUseCase();
    mockGetArtistUseCase = MockGetArtistUseCase();
    mockCreateArtistUseCase = MockCreateArtistUseCase();
    mockUpdateArtistUseCase = MockUpdateArtistUseCase();
    mockDeleteArtistUseCase = MockDeleteArtistUseCase();
    bloc = ArtistBloc(
      getArtistsUseCase: mockGetArtistsUseCase,
      getArtistUseCase: mockGetArtistUseCase,
      createArtistUseCase: mockCreateArtistUseCase,
      updateArtistUseCase: mockUpdateArtistUseCase,
      deleteArtistUseCase: mockDeleteArtistUseCase,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is ArtistInitial', () {
    expect(bloc.state, const ArtistInitial());
  });

  // ── ArtistLoadListEvent ────────────────────────────────────────────────────

  group('ArtistLoadListEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistListLoading, ArtistListLoaded] when load succeeds',
      build: () {
        when(() => mockGetArtistsUseCase(any()))
            .thenAnswer((_) async => Right(tPage));
        return bloc;
      },
      act: (b) =>
          b.add(const ArtistLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const ArtistListLoading(),
        ArtistListLoaded(
          artists: tPage.items,
          page: tPage.page,
          totalPages: tPage.totalPages,
          totalElements: tPage.totalElements,
        ),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistListLoading, ArtistListError] when load fails',
      build: () {
        when(() => mockGetArtistsUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server error', statusCode: 500),
          ),
        );
        return bloc;
      },
      act: (b) =>
          b.add(const ArtistLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const ArtistListLoading(),
        const ArtistListError(message: 'Server error'),
      ],
    );
  });

  // ── ArtistSearchEvent ──────────────────────────────────────────────────────

  group('ArtistSearchEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistListLoading, ArtistListLoaded] with query on search',
      build: () {
        when(() => mockGetArtistsUseCase(any()))
            .thenAnswer((_) async => Right(tPage));
        return bloc;
      },
      act: (b) => b.add(const ArtistSearchEvent(query: 'son tung')),
      expect: () => [
        const ArtistListLoading(),
        ArtistListLoaded(
          artists: tPage.items,
          page: tPage.page,
          totalPages: tPage.totalPages,
          totalElements: tPage.totalElements,
          query: 'son tung',
        ),
      ],
    );
  });

  // ── ArtistLoadDetailEvent ──────────────────────────────────────────────────

  group('ArtistLoadDetailEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistDetailLoading, ArtistDetailLoaded] when load succeeds',
      build: () {
        when(() => mockGetArtistUseCase(any()))
            .thenAnswer((_) async => const Right(tArtist));
        return bloc;
      },
      act: (b) => b.add(const ArtistLoadDetailEvent(id: 'uuid-1')),
      expect: () => [
        const ArtistDetailLoading(),
        const ArtistDetailLoaded(artist: tArtist),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistDetailLoading, ArtistOperationError] when load fails',
      build: () {
        when(() => mockGetArtistUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Not found', statusCode: 404),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(const ArtistLoadDetailEvent(id: 'uuid-1')),
      expect: () => [
        const ArtistDetailLoading(),
        const ArtistOperationError(message: 'Not found'),
      ],
    );
  });

  // ── ArtistCreateEvent ──────────────────────────────────────────────────────

  group('ArtistCreateEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistOperationInProgress, ArtistOperationSuccess] when create succeeds',
      build: () {
        when(() => mockCreateArtistUseCase(any()))
            .thenAnswer((_) async => const Right(tArtist));
        return bloc;
      },
      act: (b) =>
          b.add(const ArtistCreateEvent(name: 'Sơn Tùng M-TP')),
      expect: () => [
        const ArtistOperationInProgress(),
        const ArtistOperationSuccess(message: 'Nghệ sĩ đã được tạo thành công.'),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistOperationInProgress, ArtistOperationError] when create fails',
      build: () {
        when(() => mockCreateArtistUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Validation error', statusCode: 400),
          ),
        );
        return bloc;
      },
      act: (b) =>
          b.add(const ArtistCreateEvent(name: 'Sơn Tùng M-TP')),
      expect: () => [
        const ArtistOperationInProgress(),
        const ArtistOperationError(message: 'Validation error'),
      ],
    );
  });

  // ── ArtistUpdateEvent ──────────────────────────────────────────────────────

  group('ArtistUpdateEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistOperationInProgress, ArtistOperationSuccess] when update succeeds',
      build: () {
        when(() => mockUpdateArtistUseCase(any()))
            .thenAnswer((_) async => const Right(tArtist));
        return bloc;
      },
      act: (b) => b.add(
        const ArtistUpdateEvent(id: 'uuid-1', name: 'Updated Name'),
      ),
      expect: () => [
        const ArtistOperationInProgress(),
        const ArtistOperationSuccess(message: 'Nghệ sĩ đã được cập nhật thành công.'),
      ],
    );
  });

  // ── ArtistDeleteEvent ──────────────────────────────────────────────────────

  group('ArtistDeleteEvent', () {
    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistOperationInProgress, ArtistOperationSuccess] when delete succeeds',
      build: () {
        when(() => mockDeleteArtistUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const ArtistDeleteEvent(id: 'uuid-1')),
      expect: () => [
        const ArtistOperationInProgress(),
        const ArtistOperationSuccess(message: 'Nghệ sĩ đã được xóa thành công.'),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistOperationInProgress, ArtistOperationError] when delete fails',
      build: () {
        when(() => mockDeleteArtistUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Not found', statusCode: 404),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(const ArtistDeleteEvent(id: 'uuid-1')),
      expect: () => [
        const ArtistOperationInProgress(),
        const ArtistOperationError(message: 'Not found'),
      ],
    );
  });
}
