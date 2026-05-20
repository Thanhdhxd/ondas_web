import 'package:equatable/equatable.dart';

class SystemPlaylistSong extends Equatable {
  final int position;
  final String id;
  final String title;
  final String? coverUrl;
  final int? durationSeconds;

  const SystemPlaylistSong({
    required this.position,
    required this.id,
    required this.title,
    this.coverUrl,
    this.durationSeconds,
  });

  @override
  List<Object?> get props => [position, id, title, coverUrl, durationSeconds];
}
