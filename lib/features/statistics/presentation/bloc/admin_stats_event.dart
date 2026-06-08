import 'package:equatable/equatable.dart';

abstract class AdminStatsEvent extends Equatable {
  const AdminStatsEvent();

  @override
  List<Object?> get props => [];
}

class AdminStatsLoadEvent extends AdminStatsEvent {
  final String? from;
  final String? to;
  final String? dauMauDate;
  final int topLimit;

  const AdminStatsLoadEvent({
    this.from,
    this.to,
    this.dauMauDate,
    this.topLimit = 10,
  });

  @override
  List<Object?> get props => [from, to, dauMauDate, topLimit];
}
