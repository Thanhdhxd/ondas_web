import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class GetArtistsUseCase {
  Future<Either<Failure, PageResultDto<Artist>>> call(GetArtistsParams params);
}

class GetArtistsParams extends Equatable {
  final int page;
  final int size;
  final String? query;

  const GetArtistsParams({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}
