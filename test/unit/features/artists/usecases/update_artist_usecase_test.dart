import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/data/models/artist_model.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase_impl.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

void main() {
  late UpdateArtistUseCase useCase;
  late MockArtistRepository mockRepository;

  const tArtist = ArtistModel(
    id: 'uuid-1',
    name: 'Sơn Tùng M-TP Updated',
    slug: 'son-tung-m-tp',
    country: 'Vietnam',
  );

  const tParams = UpdateArtistParams(
    id: 'uuid-1',
    name: 'Sơn Tùng M-TP Updated',
  );

  setUp(() {
    mockRepository = MockArtistRepository();
    useCase = UpdateArtistUseCaseImpl(mockRepository);
  });

  group('UpdateArtistUseCase', () {
    test('should return updated Artist when update succeeds', () async {
      when(
        () => mockRepository.updateArtist(
          id: any(named: 'id'),
          name: any(named: 'name'),
          slug: any(named: 'slug'),
          bio: any(named: 'bio'),
          country: any(named: 'country'),
          avatarBytes: any(named: 'avatarBytes'),
          avatarFileName: any(named: 'avatarFileName'),
        ),
      ).thenAnswer((_) async => const Right(tArtist));

      final result = await useCase(tParams);

      expect(result, const Right(tArtist));
      verify(
        () => mockRepository.updateArtist(
          id: tParams.id,
          name: tParams.name,
          slug: tParams.slug,
          bio: tParams.bio,
          country: tParams.country,
          avatarBytes: tParams.avatarBytes,
          avatarFileName: tParams.avatarFileName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when update fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(
        () => mockRepository.updateArtist(
          id: any(named: 'id'),
          name: any(named: 'name'),
          slug: any(named: 'slug'),
          bio: any(named: 'bio'),
          country: any(named: 'country'),
          avatarBytes: any(named: 'avatarBytes'),
          avatarFileName: any(named: 'avatarFileName'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
