import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

abstract class GetAlbumsUseCase {
  Future<Either<Failure, PageResultDto<Album>>> call(GetAlbumsParams params);
}

class GetAlbumsParams extends Equatable {
  final int page;
  final int size;
  final String? query;

  const GetAlbumsParams({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}
