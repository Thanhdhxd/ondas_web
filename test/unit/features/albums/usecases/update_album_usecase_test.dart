import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/data/models/album_model.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/update_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/update_album_usecase_impl.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late UpdateAlbumUseCase useCase;
  late MockAlbumRepository mockRepository;

  const tAlbum = AlbumModel(
    id: 'uuid-1',
    title: 'Updated Album',
    artistNames: ['Artist 1'],
  );

  final tParams = UpdateAlbumParams(
    id: 'uuid-1',
    title: 'Updated Album',
    artistIds: ['artist-1'],
  );

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepository = MockAlbumRepository();
    useCase = UpdateAlbumUseCaseImpl(mockRepository);
  });

  group('UpdateAlbumUseCase', () {
    test('should return updated album when successful', () async {
      when(
        () => mockRepository.updateAlbum(
          id: any(named: 'id'),
          title: any(named: 'title'),
          slug: any(named: 'slug'),
          releaseDate: any(named: 'releaseDate'),
          albumType: any(named: 'albumType'),
          description: any(named: 'description'),
          artistIds: any(named: 'artistIds'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Right(tAlbum));

      final result = await useCase(tParams);

      expect(result, const Right(tAlbum));
      verify(
        () => mockRepository.updateAlbum(
          id: tParams.id,
          title: tParams.title,
          slug: tParams.slug,
          releaseDate: tParams.releaseDate,
          albumType: tParams.albumType,
          description: tParams.description,
          artistIds: tParams.artistIds,
          coverBytes: tParams.coverBytes,
          coverFileName: tParams.coverFileName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when request fails', () async {
      const failure = ServerFailure(message: 'Error', statusCode: 400);
      when(
        () => mockRepository.updateAlbum(
          id: any(named: 'id'),
          title: any(named: 'title'),
          slug: any(named: 'slug'),
          releaseDate: any(named: 'releaseDate'),
          albumType: any(named: 'albumType'),
          description: any(named: 'description'),
          artistIds: any(named: 'artistIds'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
