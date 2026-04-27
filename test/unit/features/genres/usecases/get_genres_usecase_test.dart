import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase_impl.dart';

class MockGenreRepository extends Mock implements GenreRepository {}

void main() {
  late GetGenresUseCase useCase;
  late MockGenreRepository mockRepository;

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

  const tParams = GetGenresParams(page: 0, size: 20);

  setUp(() {
    mockRepository = MockGenreRepository();
    useCase = GetGenresUseCaseImpl(mockRepository);
  });

  group('GetGenresUseCase', () {
    test('should return page of genres when successful', () async {
      when(
        () => mockRepository.getGenres(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      final result = await useCase(tParams);

      expect(result, Right(tPage));
      verify(
        () => mockRepository.getGenres(
          page: tParams.page,
          size: tParams.size,
          query: tParams.query,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when request fails', () async {
      const failure = ServerFailure(message: 'Server error', statusCode: 500);
      when(
        () => mockRepository.getGenres(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test('should pass query param when provided', () async {
      const paramsWithQuery = GetGenresParams(
        page: 0,
        size: 20,
        query: 'son tung',
      );
      when(
        () => mockRepository.getGenres(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      await useCase(paramsWithQuery);

      verify(
        () => mockRepository.getGenres(page: 0, size: 20, query: 'son tung'),
      ).called(1);
    });
  });
}
