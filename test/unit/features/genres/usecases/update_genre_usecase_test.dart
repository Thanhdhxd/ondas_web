import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/update_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/update_genre_usecase_impl.dart';

class MockGenreRepository extends Mock implements GenreRepository {}

void main() {
  late UpdateGenreUseCase useCase;
  late MockGenreRepository mockRepository;

  const tGenre = GenreModel(
    id: 1,
    name: 'V-Pop Updated',
    slug: 'v-pop',
    description: 'Cap nhat',
  );

  const tParams = UpdateGenreParams(id: 1, name: 'V-Pop Updated');

  setUp(() {
    mockRepository = MockGenreRepository();
    useCase = UpdateGenreUseCaseImpl(mockRepository);
  });

  group('UpdateGenreUseCase', () {
    test('should return updated Genre when update succeeds', () async {
      when(
        () => mockRepository.updateGenre(
          id: any(named: 'id'),
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
        () => mockRepository.updateGenre(
          id: tParams.id,
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

    test('should return ServerFailure when update fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(
        () => mockRepository.updateGenre(
          id: any(named: 'id'),
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
