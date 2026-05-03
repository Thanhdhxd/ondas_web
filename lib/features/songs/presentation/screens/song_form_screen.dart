import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/core/constants/api_constants.dart';
import 'package:ondas_web/core/di/injection.dart';
import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_bloc.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_event.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_state.dart';
import 'package:ondas_web/features/songs/presentation/widgets/song_form_widget.dart';

class SongFormScreen extends StatefulWidget {
  final String? songId;

  const SongFormScreen({super.key, this.songId});
  bool get isEditing => songId != null;

  @override
  State<SongFormScreen> createState() => _SongFormScreenState();
}

class _SongFormScreenState extends State<SongFormScreen> {
  bool _isOptionsLoading = true;
  String? _optionsError;
  List<SongFormOption<String>> _artistOptions = const [];
  List<SongFormOption<int>> _genreOptions = const [];
  List<SongFormOption<String>> _albumOptions = const [];
  bool _lyricsLoading = false;
  bool _lyricsSaving = false;
  String? _lyricsText;
  String? _lyricsError;

  String? get _songId {
    final id = widget.songId?.trim();
    if (id == null || id.isEmpty) return null;
    return id;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && _songId != null) {
      context.read<SongBloc>().add(SongLoadDetailEvent(id: _songId!));
      _loadLyrics();
    }
    _loadOptions();
  }

  Future<void> _loadLyrics() async {
    if (_songId == null) return;
    setState(() {
      _lyricsLoading = true;
      _lyricsError = null;
    });

    try {
      final response = await sl<DioClient>().dio.get(
        ApiConstants.songLyrics(_songId!),
      );
      if (response.data == null) {
        if (!mounted) return;
        setState(() {
          _lyricsText = '';
          _lyricsLoading = false;
          _lyricsError = null;
        });
        return;
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'];
      final lyrics = data is Map<String, dynamic>
          ? data['plainText'] as String?
          : null;
      if (body['success'] != true) {
        if (lyrics == null) {
          if (!mounted) return;
          setState(() {
            _lyricsText = '';
            _lyricsLoading = false;
            _lyricsError = null;
          });
          return;
        }
        throw Exception(body['message'] as String? ?? 'Không thể tải lyrics');
      }
      if (!mounted) return;
      setState(() {
        _lyricsText = lyrics ?? '';
        _lyricsLoading = false;
        _lyricsError = null;
      });
    } catch (error) {
      if (!mounted) return;
      if (error is DioException) {
        final statusCode = error.response?.statusCode;
        if (statusCode == 404 || statusCode == 204) {
          setState(() {
            _lyricsText = '';
            _lyricsLoading = false;
            _lyricsError = null;
          });
          return;
        }
        if (error.response?.data == null) {
          setState(() {
            _lyricsText = '';
            _lyricsLoading = false;
            _lyricsError = null;
          });
          return;
        }
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message']?.toString() ?? '';
          final success = responseData['success'];
          final data = responseData['data'];
          if (success == false && data == null) {
            setState(() {
              _lyricsText = '';
              _lyricsLoading = false;
              _lyricsError = null;
            });
            return;
          }
          if (message.contains('Lyrics not found')) {
            setState(() {
              _lyricsText = '';
              _lyricsLoading = false;
              _lyricsError = null;
            });
            return;
          }
        }
        final responseText = responseData?.toString() ?? '';
        if (responseText.contains('Lyrics not found')) {
          setState(() {
            _lyricsText = '';
            _lyricsLoading = false;
            _lyricsError = null;
          });
          return;
        }
      }
      if (error is TypeError) {
        setState(() {
          _lyricsText = '';
          _lyricsLoading = false;
          _lyricsError = null;
        });
        return;
      }
      setState(() {
        _lyricsLoading = false;
        _lyricsError = 'Không thể tải lyrics';
      });
    }
  }

  Future<void> _saveLyrics(String text) async {
    if (_songId == null) return;
    final trimmed = text.trim();
    setState(() {
      _lyricsSaving = true;
    });

    try {
      if (trimmed.isEmpty) {
        final response = await sl<DioClient>().dio.delete(
          ApiConstants.songLyrics(_songId!),
        );
        final body = response.data as Map<String, dynamic>;
        if (body['success'] != true) {
          throw Exception(body['message'] as String? ?? 'Không thể xóa lyrics');
        }
      } else {
        final response = await sl<DioClient>().dio.put(
          ApiConstants.songLyricsStatic(_songId!),
          data: {'plainText': trimmed},
        );
        final body = response.data as Map<String, dynamic>;
        if (body['success'] != true) {
          throw Exception(body['message'] as String? ?? 'Không thể lưu lyrics');
        }
      }

      if (!mounted) return;
      setState(() {
        _lyricsText = trimmed;
        _lyricsSaving = false;
        _lyricsError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            trimmed.isEmpty ? 'Lyrics đã được xóa.' : 'Lyrics đã được lưu.',
          ),
          backgroundColor: AppColors.successLight,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _lyricsSaving = false;
        _lyricsError = 'Không thể lưu lyrics';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể lưu lyrics.'),
          backgroundColor: AppColors.errorLight,
        ),
      );
    }
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isOptionsLoading = true;
      _optionsError = null;
    });

    String? error;

    final artistsResult = await sl<GetArtistsUseCase>()(
      const GetArtistsParams(page: 0, size: 200),
    );
    final artists = artistsResult.fold<List<SongFormOption<String>>>(
      (failure) {
        error ??= failure.message;
        return const <SongFormOption<String>>[];
      },
      (page) => page.items
          .map(
            (item) => SongFormOption<String>(value: item.id, label: item.name),
          )
          .toList(),
    );

    final genresResult = await sl<GetGenresUseCase>()(
      const GetGenresParams(page: 0, size: 200),
    );
    final genres = genresResult.fold<List<SongFormOption<int>>>(
      (failure) {
        error ??= failure.message;
        return const <SongFormOption<int>>[];
      },
      (page) => page.items
          .map((item) => SongFormOption<int>(value: item.id, label: item.name))
          .toList(),
    );

    final albums = await _loadAlbumOptions(
      onError: (message) {
        error ??= message;
      },
    );

    if (!mounted) return;
    setState(() {
      _artistOptions = artists;
      _genreOptions = genres;
      _albumOptions = albums;
      _isOptionsLoading = false;
      _optionsError = error;
    });
  }

  Future<List<SongFormOption<String>>> _loadAlbumOptions({
    required void Function(String message) onError,
  }) async {
    try {
      final response = await sl<DioClient>().dio.get(
        ApiConstants.albums,
        queryParameters: {'page': 0, 'size': 200},
      );
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        onError(body['message'] as String? ?? 'Không thể tải danh sách albums');
        return const <SongFormOption<String>>[];
      }

      final data = body['data'] as Map<String, dynamic>?;
      final items = (data?['items'] as List<dynamic>?) ?? const <dynamic>[];
      return items
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => SongFormOption<String>(
              value: item['id']?.toString() ?? '',
              label: (item['title'] as String?) ?? 'Untitled album',
            ),
          )
          .where((item) => item.value.isNotEmpty)
          .toList();
    } catch (_) {
      onError('Không thể tải danh sách albums');
      return const <SongFormOption<String>>[];
    }
  }

  void _onSubmit({
    required String title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    required List<String> artistIds,
    required List<int> genreIds,
    required List<int> audioBytes,
    required String audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
    bool? active,
  }) {
    final hasNewAudio = audioBytes.isNotEmpty && audioFileName.isNotEmpty;

    if (widget.isEditing && _songId != null) {
      context.read<SongBloc>().add(
        SongUpdateEvent(
          id: _songId!,
          title: title,
          albumId: albumId,
          trackNumber: trackNumber,
          releaseDate: releaseDate,
          artistIds: artistIds,
          genreIds: genreIds,
          audioBytes: hasNewAudio ? audioBytes : null,
          audioFileName: hasNewAudio ? audioFileName : null,
          active: active,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    } else {
      context.read<SongBloc>().add(
        SongCreateEvent(
          title: title,
          albumId: albumId,
          trackNumber: trackNumber,
          releaseDate: releaseDate,
          artistIds: artistIds,
          genreIds: genreIds,
          audioBytes: audioBytes,
          audioFileName: audioFileName,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;

    return BlocListener<SongBloc, SongState>(
      listener: (context, state) {
        if (state is SongOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.successLight,
            ),
          );
          context.pop(true);
        } else if (state is SongOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorLight,
            ),
          );
        }
      },
      child: ColoredBox(
        color: bgColor,
        child: BlocBuilder<SongBloc, SongState>(
          builder: (context, state) {
            final isOperationLoading = state is SongOperationInProgress;
            final isDetailLoading = state is SongDetailLoading;

            Song? initialSong;
            if (state is SongDetailLoaded) {
              initialSong = state.song;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        key: const Key('songForm_backButton'),
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                        color: textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        widget.isEditing
                            ? 'Chỉnh sửa bài hát'
                            : 'Thêm bài hát mới',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (isDetailLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SongFormWidget(
                      key: ValueKey(initialSong?.id ?? 'new'),
                      initialSong: initialSong,
                      isLoading: isOperationLoading,
                      optionsLoading: _isOptionsLoading,
                      optionsError: _optionsError,
                      lyricsText: _lyricsText,
                      lyricsLoading: _lyricsLoading,
                      lyricsSaving: _lyricsSaving,
                      lyricsError: _lyricsError,
                      lyricsEnabled: widget.isEditing,
                      artistOptions: _artistOptions,
                      genreOptions: _genreOptions,
                      albumOptions: _albumOptions,
                      onReloadOptions: _loadOptions,
                      onReloadLyrics: _loadLyrics,
                      onSaveLyrics: _saveLyrics,
                      onSubmit: _onSubmit,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
