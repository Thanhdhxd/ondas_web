import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/delete_genre_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/delete_genre_usecase_impl.dart';

class MockGenreRepository extends Mock implements GenreRepository {}

void main() {
  late DeleteGenreUseCase useCase;
  late MockGenreRepository mockRepository;

  const tParams = DeleteGenreParams(id: 1);

  setUp(() {
    mockRepository = MockGenreRepository();
    useCase = DeleteGenreUseCaseImpl(mockRepository);
  });

  group('DeleteGenreUseCase', () {
    test('should return void when deletion succeeds', () async {
      when(
        () => mockRepository.deleteGenre(id: any(named: 'id')),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, const Right(null));
      verify(() => mockRepository.deleteGenre(id: tParams.id)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when deletion fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(
        () => mockRepository.deleteGenre(id: any(named: 'id')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
