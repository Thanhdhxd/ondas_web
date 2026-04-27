import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/delete_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/delete_song_usecase_impl.dart';

class MockSongRepository extends Mock implements SongRepository {}

void main() {
  late DeleteSongUseCase useCase;
  late MockSongRepository mockRepository;

  const tParams = DeleteSongParams(id: 'uuid-1');

  setUp(() {
    mockRepository = MockSongRepository();
    useCase = DeleteSongUseCaseImpl(mockRepository);
  });

  group('DeleteSongUseCase', () {
    test('should return void when deletion succeeds', () async {
      when(() => mockRepository.deleteSong(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, const Right(null));
      verify(() => mockRepository.deleteSong(id: tParams.id)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when deletion fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(() => mockRepository.deleteSong(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
