// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

class AlbumFormOption<T> {
  final T value;
  final String label;
  /// ID của album mà bài hát đang thuộc về (null = chưa có album)
  final String? albumId;

  const AlbumFormOption({
    required this.value,
    required this.label,
    this.albumId,
  });
}

class AlbumFormWidget extends StatefulWidget {
  final Album? initialAlbum;
  final bool isLoading;
  final bool optionsLoading;
  final List<AlbumFormOption<String>> artistOptions;
  final List<AlbumFormOption<String>> songOptions;
  final void Function({
    required String title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    required List<String> artistIds,
    List<int>? coverBytes,
    String? coverFileName,
    required List<String> songIds,
  }) onSubmit;

  const AlbumFormWidget({
    super.key,
    this.initialAlbum,
    required this.isLoading,
    required this.optionsLoading,
    required this.artistOptions,
    required this.songOptions,
    required this.onSubmit,
  });

  @override
  State<AlbumFormWidget> createState() => _AlbumFormWidgetState();
}

class _AlbumFormWidgetState extends State<AlbumFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _descriptionCtrl;
  DateTime? _selectedReleaseDate;

  List<int>? _coverBytes;
  String? _coverFileName;
  Uint8List? _coverPreview;
  String? _selectedAlbumType;
  Set<String> _selectedArtistIds = <String>{};
  Set<String> _selectedSongIds = <String>{};

  bool _slugEdited = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initialAlbum;
    _titleCtrl = TextEditingController(text: a?.title ?? '');
    _slugCtrl = TextEditingController(text: a?.slug ?? '');
    _descriptionCtrl = TextEditingController(text: a?.description ?? '');
    // Parse ngày phát hành từ string 'yyyy-MM-dd'
    if (a?.releaseDate != null && a!.releaseDate!.isNotEmpty) {
      try {
        final parts = a.releaseDate!.split('-');
        _selectedReleaseDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } catch (_) {
        _selectedReleaseDate = null;
      }
    }
    final type = (a?.albumType ?? 'ALBUM').toUpperCase();
    _selectedAlbumType = ['ALBUM', 'EP', 'SINGLE'].contains(type) ? type : 'ALBUM';
    _selectedArtistIds = a?.artistIds.toSet() ?? <String>{};
    _selectedSongIds = a?.tracklist.map((t) => t.id).toSet() ?? <String>{};
    _slugEdited = a?.slug != null && a!.slug!.isNotEmpty;
    _titleCtrl.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleCtrl.removeListener(_onTitleChanged);
    _titleCtrl.dispose();
    _slugCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    if (_slugEdited) return;
    final generated = _toSlug(_titleCtrl.text);
    if (_slugCtrl.text != generated) {
      _slugCtrl.value = _slugCtrl.value.copyWith(
        text: generated,
        selection: TextSelection.collapsed(offset: generated.length),
      );
    }
  }

  static String _toSlug(String name) {
    const viMap = {
      'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      'đ': 'd',
    };
    var s = name.toLowerCase();
    s = s.split('').map((c) => viMap[c] ?? c).join();
    s = s.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    s = s.trim().replaceAll(RegExp(r'\s+'), '-');
    s = s.replaceAll(RegExp(r'-+'), '-');
    return s;
  }

  void _pickCover() {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    input.onChange.listen((event) {
      final file = input.files?.first;
      if (file == null) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoad.listen((_) {
        final bytes = reader.result as Uint8List;
        setState(() {
          _coverBytes = bytes.toList();
          _coverFileName = file.name;
          _coverPreview = bytes;
        });
      });
    });
  }

  Future<void> _pickArtists() async {
    final locale = context.read<LocaleCubit>().state.locale;
    final selected = await showDialog<Set<String>>(
      context: context,
      builder: (_) => _MultiSelectDialog<String>(
        title: AppStrings.t(AppStrings.selectArtist, locale),
        options: widget.artistOptions,
        selectedValues: _selectedArtistIds,
      ),
    );
    if (selected != null) {
      setState(() => _selectedArtistIds = selected);
    }
  }

  Future<void> _pickSongs() async {
    final selected = await showDialog<Set<String>>(
      context: context,
      builder: (_) => _SongSelectDialog(
        options: widget.songOptions,
        selectedValues: _selectedSongIds,
        currentAlbumId: widget.initialAlbum?.id,
      ),
    );
    if (selected != null) {
      setState(() => _selectedSongIds = selected);
    }
  }

  Future<void> _pickReleaseDate() async {
    final locale = context.read<LocaleCubit>().state.locale;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReleaseDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: AppStrings.t(AppStrings.releaseDate, locale),
      cancelText: AppStrings.t(AppStrings.cancel, locale),
      confirmText: AppStrings.t(AppStrings.confirm, locale),
    );
    if (picked != null) {
      setState(() => _selectedReleaseDate = picked);
    }
  }

  void _submit() {
    final locale = context.read<LocaleCubit>().state.locale;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedArtistIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.t(AppStrings.atLeastOneArtist, locale)),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    widget.onSubmit(
      title: _titleCtrl.text.trim(),
      slug: _slugCtrl.text.trim().isEmpty ? null : _slugCtrl.text.trim(),
      releaseDate: _selectedReleaseDate == null
          ? null
          : '${_selectedReleaseDate!.year.toString().padLeft(4, '0')}-'
            '${_selectedReleaseDate!.month.toString().padLeft(2, '0')}-'
            '${_selectedReleaseDate!.day.toString().padLeft(2, '0')}',
      albumType: _selectedAlbumType,
      description:
          _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      artistIds: _selectedArtistIds.toList(),
      coverBytes: _coverBytes,
      coverFileName: _coverFileName,
      songIds: _selectedSongIds.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textPrimary =
        isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.stone : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.borderLight : AppColors.darkBorder;
    final bgCard = isLight ? AppColors.snow : AppColors.darkSurface;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: main fields
                Expanded(
                  child: _FieldsCard(
                    titleCtrl: _titleCtrl,
                    slugCtrl: _slugCtrl,
                    descriptionCtrl: _descriptionCtrl,
                    selectedReleaseDate: _selectedReleaseDate,
                    onPickDate: _pickReleaseDate,
                    selectedAlbumType: _selectedAlbumType,
                    selectedArtistIds: _selectedArtistIds,
                    selectedSongIds: _selectedSongIds,
                    artistOptions: widget.artistOptions,
                    songOptions: widget.songOptions,
                    onTypeChanged: (v) => setState(() => _selectedAlbumType = v),
                    onPickArtists: _pickArtists,
                    onPickSongs: _pickSongs,
                    onSlugChanged: () => setState(() => _slugEdited = true),
                    textPrimary: textPrimary,
                    borderColor: borderColor,
                    bgCard: bgCard,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                // Right: cover upload
                SizedBox(
                  width: 240,
                  child: _CoverCard(
                    previewBytes: _coverPreview,
                    networkUrl: widget.initialAlbum?.coverUrl,
                    fileName: _coverFileName,
                    title: _titleCtrl.text,
                    isLoading: widget.isLoading,
                    borderColor: borderColor,
                    bgCard: bgCard,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onPick: _pickCover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: widget.isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSecondary,
                  side: BorderSide(color: borderColor),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.smMd,
                  ),
                ),
                child: Text(AppStrings.t(
                  AppStrings.cancel,
                  context.watch<LocaleCubit>().state.locale,
                )),
              ),
              const SizedBox(width: AppSpacing.md),
              ElevatedButton(
                onPressed: (widget.isLoading || widget.optionsLoading) ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.nearBlack,
                  foregroundColor: AppColors.pureWhite,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.smMd,
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.pureWhite,
                        ),
                      )
                    : Text(
                        widget.initialAlbum != null
                            ? AppStrings.t(AppStrings.updateBtn, context.watch<LocaleCubit>().state.locale)
                            : AppStrings.t(AppStrings.createBtn, context.watch<LocaleCubit>().state.locale),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldsCard extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController slugCtrl;
  final DateTime? selectedReleaseDate;
  final VoidCallback onPickDate;
  final TextEditingController descriptionCtrl;
  final String? selectedAlbumType;
  final Set<String> selectedArtistIds;
  final Set<String> selectedSongIds;
  final List<AlbumFormOption<String>> artistOptions;
  final List<AlbumFormOption<String>> songOptions;
  final ValueChanged<String?> onTypeChanged;
  final VoidCallback onPickArtists;
  final VoidCallback onPickSongs;
  final VoidCallback onSlugChanged;
  final Color textPrimary;
  final Color borderColor;
  final Color bgCard;

  const _FieldsCard({
    required this.titleCtrl,
    required this.slugCtrl,
    required this.selectedReleaseDate,
    required this.onPickDate,
    required this.descriptionCtrl,
    required this.selectedAlbumType,
    required this.selectedArtistIds,
    required this.selectedSongIds,
    required this.artistOptions,
    required this.songOptions,
    required this.onTypeChanged,
    required this.onPickArtists,
    required this.onPickSongs,
    required this.onSlugChanged,
    required this.textPrimary,
    required this.borderColor,
    required this.bgCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.t(AppStrings.albumInfo, context.watch<LocaleCubit>().state.locale),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _FormField(
            label: AppStrings.t(AppStrings.albumTitle, context.watch<LocaleCubit>().state.locale),
            controller: titleCtrl,
            hintText: 'VD: Tâm 9',
            textColor: textPrimary,
            borderColor: borderColor,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? AppStrings.t(AppStrings.titleRequired, context.watch<LocaleCubit>().state.locale)
                : null,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.t(AppStrings.albumType, context.watch<LocaleCubit>().state.locale),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<String>(
                      value: selectedAlbumType,
                      items: const [
                        DropdownMenuItem(value: 'ALBUM', child: Text('Album')),
                        DropdownMenuItem(value: 'EP', child: Text('EP')),
                        DropdownMenuItem(value: 'SINGLE', child: Text('Single')),
                      ],
                      onChanged: onTypeChanged,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.smMd,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                          borderSide: const BorderSide(
                            color: AppColors.nearBlack,
                            width: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.t(AppStrings.releaseDate, context.watch<LocaleCubit>().state.locale),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    InkWell(
                      onTap: onPickDate,
                      borderRadius: BorderRadius.circular(AppRadius.container),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.smMd,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedReleaseDate == null
                                    ? AppStrings.t(AppStrings.pickDate, context.watch<LocaleCubit>().state.locale)
                                    : '${selectedReleaseDate!.day.toString().padLeft(2, '0')}/'
                                      '${selectedReleaseDate!.month.toString().padLeft(2, '0')}/'
                                      '${selectedReleaseDate!.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedReleaseDate == null
                                      ? textPrimary.withAlpha(100)
                                      : textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: textPrimary.withAlpha(150),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _FormField(
            label: 'Slug',
            controller: slugCtrl,
            hintText: 'tam-9',
            textColor: textPrimary,
            borderColor: borderColor,
            onChanged: (_) => onSlugChanged(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _MultiSelectField<String>(
            label: '${AppStrings.t(AppStrings.selectArtist, context.watch<LocaleCubit>().state.locale)} *',
            options: artistOptions,
            selectedValues: selectedArtistIds,
            onTap: onPickArtists,
            borderColor: borderColor,
            textColor: textPrimary,
            hintText: AppStrings.t(AppStrings.selectArtist, context.watch<LocaleCubit>().state.locale),
          ),
          const SizedBox(height: AppSpacing.xl),
          _MultiSelectField<String>(
            label: AppStrings.t(AppStrings.tracklist, context.watch<LocaleCubit>().state.locale),
            options: songOptions,
            selectedValues: selectedSongIds,
            onTap: onPickSongs,
            borderColor: borderColor,
            textColor: textPrimary,
            hintText: AppStrings.t(AppStrings.selectSong, context.watch<LocaleCubit>().state.locale),
          ),
          const SizedBox(height: AppSpacing.xl),
          _FormField(
            label: AppStrings.t(AppStrings.albumDescription, context.watch<LocaleCubit>().state.locale),
            controller: descriptionCtrl,
            hintText: '${AppStrings.t(AppStrings.albumDescription, context.watch<LocaleCubit>().state.locale)}...',
            textColor: textPrimary,
            borderColor: borderColor,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  final Uint8List? previewBytes;
  final String? networkUrl;
  final String? fileName;
  final String title;
  final bool isLoading;
  final Color borderColor;
  final Color bgCard;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onPick;

  const _CoverCard({
    required this.previewBytes,
    required this.networkUrl,
    required this.fileName,
    required this.title,
    required this.isLoading,
    required this.borderColor,
    required this.bgCard,
    required this.textPrimary,
    required this.textSecondary,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (previewBytes != null) {
      image = MemoryImage(previewBytes!);
    } else if (networkUrl != null && networkUrl!.isNotEmpty) {
      image = NetworkImage(networkUrl!);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.t(AppStrings.coverImage, context.watch<LocaleCubit>().state.locale),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.container),
                color: AppColors.darkSurfaceElevated,
                image: image != null
                    ? DecorationImage(image: image, fit: BoxFit.cover)
                    : null,
              ),
              child: image == null
                  ? const Icon(Icons.album, size: 48, color: AppColors.stone)
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: isLoading ? null : onPick,
            icon: const Icon(Icons.upload_outlined, size: 14),
            label: Text(AppStrings.t(AppStrings.uploadImage, context.watch<LocaleCubit>().state.locale)),
            style: OutlinedButton.styleFrom(
              foregroundColor: textSecondary,
              side: BorderSide(color: borderColor),
              shape: const StadiumBorder(),
            ),
          ),
          if (fileName != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              fileName!,
              style: const TextStyle(fontSize: 11, color: AppColors.stone),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          Text(
            AppStrings.t(AppStrings.imageHint, context.watch<LocaleCubit>().state.locale),
            style: const TextStyle(fontSize: 11, color: AppColors.stone),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final Color textColor;
  final Color borderColor;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.textColor,
    required this.borderColor,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.smMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: const BorderSide(
                color: AppColors.nearBlack,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final List<AlbumFormOption<T>> options;
  final Set<T> selectedValues;
  final VoidCallback onTap;
  final Color borderColor;
  final Color textColor;

  const _MultiSelectField({
    required this.label,
    required this.hintText,
    required this.options,
    required this.selectedValues,
    required this.onTap,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLabels = options
        .where((option) => selectedValues.contains(option.value))
        .map((option) => option.label)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.container),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smMd,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.container),
              border: Border.all(color: borderColor),
            ),
            child: selectedLabels.isEmpty
                ? Text(hintText, style: TextStyle(color: textColor.withAlpha(100)))
                : Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: selectedLabels
                        .map(
                          (label) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoSurfaceLight,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: AppColors.infoLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectDialog<T> extends StatefulWidget {
  final String title;
  final List<AlbumFormOption<T>> options;
  final Set<T> selectedValues;

  const _MultiSelectDialog({
    required this.title,
    required this.options,
    required this.selectedValues,
  });

  @override
  State<_MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<_MultiSelectDialog<T>> {
  late Set<T> _working;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _working = Set<T>.from(widget.selectedValues);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = widget.options
        .where((o) => o.label.toLowerCase().contains(_searchQuery))
        .toList();

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        height: 480,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: '${AppStrings.t(AppStrings.search, context.watch<LocaleCubit>().state.locale)}...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return CheckboxListTile(
                    value: _working.contains(option.value),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _working.add(option.value);
                        } else {
                          _working.remove(option.value);
                        }
                      });
                    },
                    title: Text(option.label),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.t(AppStrings.cancel, context.watch<LocaleCubit>().state.locale)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_working),
          child: Text(AppStrings.t(AppStrings.confirm, context.watch<LocaleCubit>().state.locale)),
        ),
      ],
    );
  }
}

// ── Dialog chọn bài hát (có kiểm tra bài hát đã thuộc album khác) ─────────────

class _SongSelectDialog extends StatefulWidget {
  final List<AlbumFormOption<String>> options;
  final Set<String> selectedValues;
  /// ID album đang chỉnh sửa (null = tạo mới)
  final String? currentAlbumId;

  const _SongSelectDialog({
    required this.options,
    required this.selectedValues,
    required this.currentAlbumId,
  });

  @override
  State<_SongSelectDialog> createState() => _SongSelectDialogState();
}

class _SongSelectDialogState extends State<_SongSelectDialog> {
  late Set<String> _working;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _working = Set<String>.from(widget.selectedValues);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Bài hát có đang thuộc album KHÁC (không phải album hiện tại) không?
  bool _isLockedByOtherAlbum(AlbumFormOption<String> option) {
    if (option.albumId == null || option.albumId!.isEmpty) return false;
    // Nếu đang tạo mới (currentAlbumId == null), mọi bài có albumId đều bị khoá
    if (widget.currentAlbumId == null) return true;
    // Nếu đang edit, chỉ khoá bài thuộc album khác
    return option.albumId != widget.currentAlbumId;
  }

  void _onToggle(AlbumFormOption<String> option, bool? selected) {
    if (_isLockedByOtherAlbum(option)) {
      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${option.label}" đã được thêm vào một album khác rồi.',
          ),
          backgroundColor: AppColors.errorLight,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      if (selected == true) {
        _working.add(option.value);
      } else {
        _working.remove(option.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = widget.options
        .where((o) => o.label.toLowerCase().contains(_searchQuery))
        .toList();

    return AlertDialog(
      title: Text(AppStrings.t(AppStrings.selectSong, context.watch<LocaleCubit>().state.locale)),
      content: SizedBox(
        width: 420,
        height: 480,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: '${AppStrings.t(AppStrings.search, context.watch<LocaleCubit>().state.locale)}...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Legend
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Đã thuộc album khác',
                  style: TextStyle(fontSize: 11, color: AppColors.stone),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  final locked = _isLockedByOtherAlbum(option);
                  return CheckboxListTile(
                    value: _working.contains(option.value),
                    onChanged: locked
                        ? (v) => _onToggle(option, v)
                        : (v) => _onToggle(option, v),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              color: locked ? AppColors.stone : null,
                              decoration: locked
                                  ? TextDecoration.none
                                  : null,
                            ),
                          ),
                        ),
                        if (locked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppStrings.t(AppStrings.songAlreadyInAlbum, context.watch<LocaleCubit>().state.locale),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.errorLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    tileColor: locked
                        ? AppColors.errorLight.withAlpha(8)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.t(AppStrings.cancel, context.watch<LocaleCubit>().state.locale)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_working),
          child: Text(AppStrings.t(AppStrings.confirm, context.watch<LocaleCubit>().state.locale)),
        ),
      ],
    );
  }
}
