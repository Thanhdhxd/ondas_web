import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';

abstract class GetGenresUseCase {
  Future<Either<Failure, PageResultDto<Genre>>> call(GetGenresParams params);
}

class GetGenresParams extends Equatable {
  final int page;
  final int size;
  final String? query;

  const GetGenresParams({required this.page, required this.size, this.query});

  @override
  List<Object?> get props => [page, size, query];
}
