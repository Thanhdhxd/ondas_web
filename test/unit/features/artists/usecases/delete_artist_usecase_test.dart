import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase_impl.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

void main() {
  late DeleteArtistUseCase useCase;
  late MockArtistRepository mockRepository;

  const tParams = DeleteArtistParams(id: 'uuid-1');

  setUp(() {
    mockRepository = MockArtistRepository();
    useCase = DeleteArtistUseCaseImpl(mockRepository);
  });

  group('DeleteArtistUseCase', () {
    test('should return void when deletion succeeds', () async {
      when(
        () => mockRepository.deleteArtist(id: any(named: 'id')),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, const Right(null));
      verify(() => mockRepository.deleteArtist(id: tParams.id)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when deletion fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(
        () => mockRepository.deleteArtist(id: any(named: 'id')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
