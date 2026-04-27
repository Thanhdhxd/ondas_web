import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';
import 'package:ondas_web/features/genres/domain/usecases/create_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/delete_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/update_genre_usecase.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_bloc.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_event.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_state.dart';

class MockGetGenresUseCase extends Mock implements GetGenresUseCase {}

class MockGetGenreUseCase extends Mock implements GetGenreUseCase {}

class MockCreateGenreUseCase extends Mock implements CreateGenreUseCase {}

class MockUpdateGenreUseCase extends Mock implements UpdateGenreUseCase {}

class MockDeleteGenreUseCase extends Mock implements DeleteGenreUseCase {}

void main() {
  late GenreBloc bloc;
  late MockGetGenresUseCase mockGetGenresUseCase;
  late MockGetGenreUseCase mockGetGenreUseCase;
  late MockCreateGenreUseCase mockCreateGenreUseCase;
  late MockUpdateGenreUseCase mockUpdateGenreUseCase;
  late MockDeleteGenreUseCase mockDeleteGenreUseCase;

  const tGenre = GenreModel(
    id: 1,
    name: 'V-Pop',
    slug: 'v-pop',
    description: 'Nhac Viet',
  );

  final tPage = PageResultDto<GenreModel>(
    items: [tGenre],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  setUpAll(() {
    registerFallbackValue(const GetGenresParams(page: 0, size: 20));
    registerFallbackValue(const GetGenreParams(id: 1));
    registerFallbackValue(const CreateGenreParams(name: 'Test'));
    registerFallbackValue(const UpdateGenreParams(id: 1));
    registerFallbackValue(const DeleteGenreParams(id: 1));
  });

  setUp(() {
    mockGetGenresUseCase = MockGetGenresUseCase();
    mockGetGenreUseCase = MockGetGenreUseCase();
    mockCreateGenreUseCase = MockCreateGenreUseCase();
    mockUpdateGenreUseCase = MockUpdateGenreUseCase();
    mockDeleteGenreUseCase = MockDeleteGenreUseCase();
    bloc = GenreBloc(
      getGenresUseCase: mockGetGenresUseCase,
      getGenreUseCase: mockGetGenreUseCase,
      createGenreUseCase: mockCreateGenreUseCase,
      updateGenreUseCase: mockUpdateGenreUseCase,
      deleteGenreUseCase: mockDeleteGenreUseCase,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is GenreInitial', () {
    expect(bloc.state, const GenreInitial());
  });

  // ── GenreLoadListEvent ────────────────────────────────────────────────────

  group('GenreLoadListEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreListLoading, GenreListLoaded] when load succeeds',
      build: () {
        when(
          () => mockGetGenresUseCase(any()),
        ).thenAnswer((_) async => Right(tPage));
        return bloc;
      },
      act: (b) => b.add(const GenreLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const GenreListLoading(),
        GenreListLoaded(
          genres: tPage.items,
          page: tPage.page,
          totalPages: tPage.totalPages,
          totalElements: tPage.totalElements,
        ),
      ],
    );

    blocTest<GenreBloc, GenreState>(
      'emits [GenreListLoading, GenreListError] when load fails',
      build: () {
        when(() => mockGetGenresUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server error', statusCode: 500),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(const GenreLoadListEvent(page: 0, size: 20)),
      expect: () => [
        const GenreListLoading(),
        const GenreListError(message: 'Server error'),
      ],
    );
  });

  // ── GenreSearchEvent ──────────────────────────────────────────────────────

  group('GenreSearchEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreListLoading, GenreListLoaded] with query on search',
      build: () {
        when(
          () => mockGetGenresUseCase(any()),
        ).thenAnswer((_) async => Right(tPage));
        return bloc;
      },
      act: (b) => b.add(const GenreSearchEvent(query: 'son tung')),
      expect: () => [
        const GenreListLoading(),
        GenreListLoaded(
          genres: tPage.items,
          page: tPage.page,
          totalPages: tPage.totalPages,
          totalElements: tPage.totalElements,
          query: 'son tung',
        ),
      ],
    );
  });

  // ── GenreLoadDetailEvent ──────────────────────────────────────────────────

  group('GenreLoadDetailEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreDetailLoading, GenreDetailLoaded] when load succeeds',
      build: () {
        when(
          () => mockGetGenreUseCase(any()),
        ).thenAnswer((_) async => const Right(tGenre));
        return bloc;
      },
      act: (b) => b.add(const GenreLoadDetailEvent(id: 1)),
      expect: () => [
        const GenreDetailLoading(),
        const GenreDetailLoaded(genre: tGenre),
      ],
    );

    blocTest<GenreBloc, GenreState>(
      'emits [GenreDetailLoading, GenreOperationError] when load fails',
      build: () {
        when(() => mockGetGenreUseCase(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Not found', statusCode: 404)),
        );
        return bloc;
      },
      act: (b) => b.add(const GenreLoadDetailEvent(id: 1)),
      expect: () => [
        const GenreDetailLoading(),
        const GenreOperationError(message: 'Not found'),
      ],
    );
  });

  // ── GenreCreateEvent ──────────────────────────────────────────────────────

  group('GenreCreateEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreOperationInProgress, GenreOperationSuccess] when create succeeds',
      build: () {
        when(
          () => mockCreateGenreUseCase(any()),
        ).thenAnswer((_) async => const Right(tGenre));
        return bloc;
      },
      act: (b) => b.add(const GenreCreateEvent(name: 'V-Pop')),
      expect: () => [
        const GenreOperationInProgress(),
        const GenreOperationSuccess(
          message: 'Thể loại đã được tạo thành công.',
        ),
      ],
    );

    blocTest<GenreBloc, GenreState>(
      'emits [GenreOperationInProgress, GenreOperationError] when create fails',
      build: () {
        when(() => mockCreateGenreUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Validation error', statusCode: 400),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(const GenreCreateEvent(name: 'V-Pop')),
      expect: () => [
        const GenreOperationInProgress(),
        const GenreOperationError(message: 'Validation error'),
      ],
    );
  });

  // ── GenreUpdateEvent ──────────────────────────────────────────────────────

  group('GenreUpdateEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreOperationInProgress, GenreOperationSuccess] when update succeeds',
      build: () {
        when(
          () => mockUpdateGenreUseCase(any()),
        ).thenAnswer((_) async => const Right(tGenre));
        return bloc;
      },
      act: (b) => b.add(const GenreUpdateEvent(id: 1, name: 'Updated Name')),
      expect: () => [
        const GenreOperationInProgress(),
        const GenreOperationSuccess(
          message: 'Thể loại đã được cập nhật thành công.',
        ),
      ],
    );
  });

  // ── GenreDeleteEvent ──────────────────────────────────────────────────────

  group('GenreDeleteEvent', () {
    blocTest<GenreBloc, GenreState>(
      'emits [GenreOperationInProgress, GenreOperationSuccess] when delete succeeds',
      build: () {
        when(
          () => mockDeleteGenreUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const GenreDeleteEvent(id: 1)),
      expect: () => [
        const GenreOperationInProgress(),
        const GenreOperationSuccess(
          message: 'Thể loại đã được xóa thành công.',
        ),
      ],
    );

    blocTest<GenreBloc, GenreState>(
      'emits [GenreOperationInProgress, GenreOperationError] when delete fails',
      build: () {
        when(() => mockDeleteGenreUseCase(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Not found', statusCode: 404)),
        );
        return bloc;
      },
      act: (b) => b.add(const GenreDeleteEvent(id: 1)),
      expect: () => [
        const GenreOperationInProgress(),
        const GenreOperationError(message: 'Not found'),
      ],
    );
  });
}
