import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class GetSongsUseCase {
  Future<Either<Failure, PageResultDto<Song>>> call(GetSongsParams params);
}

class GetSongsParams extends Equatable {
  final int page;
  final int size;
  final String? query;

  const GetSongsParams({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}
