import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/create_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/create_genre_usecase_impl.dart';

class MockGenreRepository extends Mock implements GenreRepository {}

void main() {
  late CreateGenreUseCase useCase;
  late MockGenreRepository mockRepository;

  const tGenre = GenreModel(
    id: 1,
    name: 'V-Pop',
    slug: 'v-pop',
    description: 'Nhac Viet',
  );

  const tParams = CreateGenreParams(
    name: 'V-Pop',
    slug: 'v-pop',
    description: 'Nhac Viet',
  );

  setUp(() {
    mockRepository = MockGenreRepository();
    useCase = CreateGenreUseCaseImpl(mockRepository);
  });

  group('CreateGenreUseCase', () {
    test('should return Genre when creation succeeds', () async {
      when(
        () => mockRepository.createGenre(
          name: any(named: 'name'),
          slug: any(named: 'slug'),
          description: any(named: 'description'),
          coverUrl: any(named: 'coverUrl'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Right(tGenre));

      final result = await useCase(tParams);

      expect(result, const Right(tGenre));
      verify(
        () => mockRepository.createGenre(
          name: tParams.name,
          slug: tParams.slug,
          description: tParams.description,
          coverUrl: tParams.coverUrl,
          coverBytes: tParams.coverBytes,
          coverFileName: tParams.coverFileName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when creation fails', () async {
      const failure = ServerFailure(
        message: 'Validation error',
        statusCode: 400,
      );
      when(
        () => mockRepository.createGenre(
          name: any(named: 'name'),
          slug: any(named: 'slug'),
          description: any(named: 'description'),
          coverUrl: any(named: 'coverUrl'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
