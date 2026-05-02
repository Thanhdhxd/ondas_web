// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

class SongFormOption<T> {
  final T value;
  final String label;

  const SongFormOption({required this.value, required this.label});
}

class SongFormWidget extends StatefulWidget {
  final Song? initialSong;
  final bool isLoading;
  final bool optionsLoading;
  final String? optionsError;
  final String? lyricsText;
  final bool lyricsLoading;
  final bool lyricsSaving;
  final String? lyricsError;
  final bool lyricsEnabled;
  final List<SongFormOption<String>> artistOptions;
  final List<SongFormOption<int>> genreOptions;
  final List<SongFormOption<String>> albumOptions;
  final Future<void> Function()? onReloadOptions;
  final Future<void> Function()? onReloadLyrics;
  final Future<void> Function(String text)? onSaveLyrics;
  final void Function({
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
  })
  onSubmit;

  const SongFormWidget({
    super.key,
    this.initialSong,
    required this.isLoading,
    required this.optionsLoading,
    required this.optionsError,
    required this.lyricsText,
    required this.lyricsLoading,
    required this.lyricsSaving,
    required this.lyricsError,
    required this.lyricsEnabled,
    required this.artistOptions,
    required this.genreOptions,
    required this.albumOptions,
    this.onReloadOptions,
    this.onReloadLyrics,
    this.onSaveLyrics,
    required this.onSubmit,
  });

  @override
  State<SongFormWidget> createState() => _SongFormWidgetState();
}

class _SongFormWidgetState extends State<SongFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _trackNumberCtrl;
  late final TextEditingController _lyricsCtrl;
  DateTime? _selectedReleaseDate;

  List<int>? _audioBytes;
  String? _audioFileName;
  List<int>? _coverBytes;
  String? _coverFileName;
  Uint8List? _coverPreview;
  bool _active = true;

  String? _selectedAlbumId;
  Set<String> _selectedArtistIds = <String>{};
  Set<int> _selectedGenreIds = <int>{};

  bool get _isEditing => widget.initialSong != null;

  @override
  void initState() {
    super.initState();
    final song = widget.initialSong;
    _titleCtrl = TextEditingController(text: song?.title ?? '');
    _trackNumberCtrl = TextEditingController(
      text: song?.trackNumber == null ? '' : '${song!.trackNumber}',
    );
    _lyricsCtrl = TextEditingController(text: widget.lyricsText ?? '');
    // Parse ngày phát hành từ string 'yyyy-MM-dd'
    if (song?.releaseDate != null && song!.releaseDate!.isNotEmpty) {
      try {
        final parts = song.releaseDate!.split('-');
        _selectedReleaseDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } catch (_) {
        _selectedReleaseDate = null;
      }
    }
    _selectedAlbumId = song?.albumId;
    _selectedArtistIds = song == null ? <String>{} : song.artistIds.toSet();
    _selectedGenreIds = song == null ? <int>{} : song.genreIds.toSet();
    _active = song?.active ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _trackNumberCtrl.dispose();
    _lyricsCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SongFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lyricsText != widget.lyricsText &&
        (widget.lyricsText ?? '') != _lyricsCtrl.text) {
      _lyricsCtrl.text = widget.lyricsText ?? '';
    }
  }

  void _pickAudio() {
    final input = html.FileUploadInputElement()
      ..accept = 'audio/*'
      ..click();

    input.onChange.listen((_) {
      final file = input.files?.first;
      if (file == null) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoad.listen((_) {
        final bytes = reader.result as Uint8List;
        setState(() {
          _audioBytes = bytes.toList();
          _audioFileName = file.name;
        });
      });
    });
  }

  void _pickCover() {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    input.onChange.listen((_) {
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
    final selected = await showDialog<Set<String>>(
      context: context,
      builder: (_) => _MultiSelectDialog<String>(
        title: 'Chọn nghệ sĩ',
        options: widget.artistOptions,
        selectedValues: _selectedArtistIds,
      ),
    );
    if (selected != null) {
      setState(() => _selectedArtistIds = selected);
    }
  }

  Future<void> _pickGenres() async {
    final selected = await showDialog<Set<int>>(
      context: context,
      builder: (_) => _MultiSelectDialog<int>(
        title: 'Chọn thể loại',
        options: widget.genreOptions,
        selectedValues: _selectedGenreIds,
      ),
    );
    if (selected != null) {
      setState(() => _selectedGenreIds = selected);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedArtistIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 nghệ sĩ.'),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    if (_selectedGenreIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 thể loại.'),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    if (!_isEditing && (_audioBytes == null || _audioFileName == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn file audio khi tạo bài hát mới.'),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    final trackNumberText = _trackNumberCtrl.text.trim();

    widget.onSubmit(
      title: _titleCtrl.text.trim(),
      albumId: _selectedAlbumId,
      trackNumber: trackNumberText.isEmpty
          ? null
          : int.tryParse(trackNumberText),
      releaseDate: _selectedReleaseDate == null
          ? null
          : '${_selectedReleaseDate!.year.toString().padLeft(4, '0')}-'
                '${_selectedReleaseDate!.month.toString().padLeft(2, '0')}-'
                '${_selectedReleaseDate!.day.toString().padLeft(2, '0')}',
      artistIds: _selectedArtistIds.toList(),
      genreIds: _selectedGenreIds.toList(),
      audioBytes: _audioBytes ?? const <int>[],
      audioFileName: _audioFileName ?? '',
      coverBytes: _coverBytes,
      coverFileName: _coverFileName,
      active: _active,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.borderLight : AppColors.darkBorder;
    final bgCard = isLight ? AppColors.snow : AppColors.darkSurface;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.optionsError != null)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorSurfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.container),
                border: Border.all(color: AppColors.errorLight),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: AppColors.errorLight,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.optionsError!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.errorLight,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onReloadOptions,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _FieldsCard(
                    titleCtrl: _titleCtrl,
                    trackNumberCtrl: _trackNumberCtrl,
                    selectedReleaseDate: _selectedReleaseDate,
                    onPickDate: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedReleaseDate ?? now,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        helpText: 'Chọn ngày phát hành',
                        cancelText: 'Hủy',
                        confirmText: 'Chọn',
                      );
                      if (picked != null) {
                        setState(() => _selectedReleaseDate = picked);
                      }
                    },
                    selectedAlbumId: _selectedAlbumId,
                    selectedArtistIds: _selectedArtistIds,
                    selectedGenreIds: _selectedGenreIds,
                    albumOptions: widget.albumOptions,
                    artistOptions: widget.artistOptions,
                    genreOptions: widget.genreOptions,
                    optionsLoading: widget.optionsLoading,
                    onAlbumChanged: (value) =>
                        setState(() => _selectedAlbumId = value),
                    onPickArtists: _pickArtists,
                    onPickGenres: _pickGenres,
                    active: _active,
                    onActiveChanged: (value) => setState(() => _active = value),
                    isEditing: _isEditing,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: borderColor,
                    bgCard: bgCard,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                SizedBox(
                  width: 260,
                  child: _MediaCard(
                    coverPreview: _coverPreview,
                    coverUrl: widget.initialSong?.coverUrl,
                    audioFileName: _audioFileName,
                    coverFileName: _coverFileName,
                    isLoading: widget.isLoading,
                    borderColor: borderColor,
                    bgCard: bgCard,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onPickAudio: _pickAudio,
                    onPickCover: _pickCover,
                    isEditing: _isEditing,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _LyricsCard(
            controller: _lyricsCtrl,
            enabled: widget.lyricsEnabled,
            isLoading: widget.lyricsLoading,
            isSaving: widget.lyricsSaving,
            errorText: widget.lyricsError,
            onReload: widget.onReloadLyrics,
            onSave: widget.onSaveLyrics,
            borderColor: borderColor,
            bgCard: bgCard,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                key: const Key('songForm_backButton'),
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
                child: const Text('Hủy'),
              ),
              const SizedBox(width: AppSpacing.md),
              ElevatedButton(
                key: const Key('songForm_submitButton'),
                onPressed: (widget.isLoading || widget.optionsLoading)
                    ? null
                    : _submit,
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
                    : Text(widget.initialSong != null ? 'Cập nhật' : 'Tạo mới'),
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
  final TextEditingController trackNumberCtrl;
  final DateTime? selectedReleaseDate;
  final VoidCallback onPickDate;
  final String? selectedAlbumId;
  final Set<String> selectedArtistIds;
  final Set<int> selectedGenreIds;
  final List<SongFormOption<String>> albumOptions;
  final List<SongFormOption<String>> artistOptions;
  final List<SongFormOption<int>> genreOptions;
  final bool optionsLoading;
  final ValueChanged<String?> onAlbumChanged;
  final VoidCallback onPickArtists;
  final VoidCallback onPickGenres;
  final bool active;
  final ValueChanged<bool> onActiveChanged;
  final bool isEditing;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final Color bgCard;

  const _FieldsCard({
    required this.titleCtrl,
    required this.trackNumberCtrl,
    required this.selectedReleaseDate,
    required this.onPickDate,
    required this.selectedAlbumId,
    required this.selectedArtistIds,
    required this.selectedGenreIds,
    required this.albumOptions,
    required this.artistOptions,
    required this.genreOptions,
    required this.optionsLoading,
    required this.onAlbumChanged,
    required this.onPickArtists,
    required this.onPickGenres,
    required this.active,
    required this.onActiveChanged,
    required this.isEditing,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.bgCard,
  });

  @override
  Widget build(BuildContext context) {
    final safeAlbumValue = albumOptions.any((e) => e.value == selectedAlbumId)
        ? selectedAlbumId
        : null;

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
          Row(
            children: [
              Text(
                'Thông tin bài hát',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (optionsLoading) ...[
                const SizedBox(width: AppSpacing.md),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          _FormField(
            key: const Key('songForm_titleField'),
            label: 'Tiêu đề *',
            controller: titleCtrl,
            hintText: 'VD: Nơi này có anh',
            textColor: textPrimary,
            borderColor: borderColor,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
          ),
          const SizedBox(height: AppSpacing.xl),
          DropdownButtonFormField<String?>(
            key: ValueKey<String?>('songForm_albumDropdown_$safeAlbumValue'),
            initialValue: safeAlbumValue,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Khong gan album'),
              ),
              ...albumOptions.map(
                (option) => DropdownMenuItem<String?>(
                  value: option.value,
                  child: Text(option.label),
                ),
              ),
            ],
            onChanged: optionsLoading ? null : onAlbumChanged,
            decoration: InputDecoration(
              labelText: 'Album',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.container),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.container),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: _FormField(
                  key: const Key('songForm_trackNumberField'),
                  label: 'Track number',
                  controller: trackNumberCtrl,
                  hintText: '1',
                  textColor: textPrimary,
                  borderColor: borderColor,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final text = (v ?? '').trim();
                    if (text.isEmpty) return null;
                    return int.tryParse(text) == null
                        ? 'Phải là số nguyên'
                        : null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày phát hành',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
                          borderRadius: BorderRadius.circular(
                            AppRadius.container,
                          ),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedReleaseDate == null
                                    ? 'Chọn ngày...'
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
          _MultiSelectField<String>(
            key: const Key('songForm_artistMultiSelect'),
            label: 'Nghệ sĩ *',
            options: artistOptions,
            selectedValues: selectedArtistIds,
            onTap: optionsLoading ? null : onPickArtists,
            borderColor: borderColor,
            textColor: textPrimary,
            hintText: 'Chọn nghệ sĩ',
          ),
          const SizedBox(height: AppSpacing.xl),
          _MultiSelectField<int>(
            key: const Key('songForm_genreMultiSelect'),
            label: 'Thể loại *',
            options: genreOptions,
            selectedValues: selectedGenreIds,
            onTap: optionsLoading ? null : onPickGenres,
            borderColor: borderColor,
            textColor: textPrimary,
            hintText: 'Chọn thể loại',
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Checkbox(
                value: active,
                onChanged: isEditing
                    ? (value) => onActiveChanged(value ?? true)
                    : null,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text('Active', style: TextStyle(color: textPrimary)),
              const SizedBox(width: AppSpacing.sm),
              if (!isEditing)
                Text(
                  '(Chỉ sửa khi edit)',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MultiSelectField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final List<SongFormOption<T>> options;
  final Set<T> selectedValues;
  final VoidCallback? onTap;
  final Color borderColor;
  final Color textColor;

  const _MultiSelectField({
    super.key,
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
        Text(label, style: TextStyle(color: textColor)),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.container),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smMd,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.container),
              border: Border.all(color: borderColor),
            ),
            child: selectedLabels.isEmpty
                ? Text(
                    hintText,
                    style: TextStyle(color: textColor.withValues(alpha: 0.5)),
                  )
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
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
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
  final List<SongFormOption<T>> options;
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

  @override
  void initState() {
    super.initState();
    _working = Set<T>.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        height: 360,
        child: ListView(
          children: widget.options
              .map(
                (option) => CheckboxListTile(
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
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_working),
          child: const Text('Xong'),
        ),
      ],
    );
  }
}

class _MediaCard extends StatelessWidget {
  final Uint8List? coverPreview;
  final String? coverUrl;
  final String? audioFileName;
  final String? coverFileName;
  final bool isLoading;
  final Color borderColor;
  final Color bgCard;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onPickAudio;
  final VoidCallback onPickCover;
  final bool isEditing;

  const _MediaCard({
    required this.coverPreview,
    required this.coverUrl,
    required this.audioFileName,
    required this.coverFileName,
    required this.isLoading,
    required this.borderColor,
    required this.bgCard,
    required this.textPrimary,
    required this.textSecondary,
    required this.onPickAudio,
    required this.onPickCover,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (coverPreview != null) {
      image = MemoryImage(coverPreview!);
    } else if (coverUrl != null && coverUrl!.isNotEmpty) {
      image = NetworkImage(coverUrl!);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Media',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.container),
                color: AppColors.lightGray,
                image: image == null
                    ? null
                    : DecorationImage(image: image, fit: BoxFit.cover),
              ),
              alignment: Alignment.center,
              child: image == null
                  ? const Icon(Icons.image_outlined, color: AppColors.stone)
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            key: const Key('songForm_coverPickButton'),
            onPressed: isLoading ? null : onPickCover,
            icon: const Icon(Icons.upload_outlined, size: 14),
            label: const Text('Tải ảnh cover'),
            style: OutlinedButton.styleFrom(
              foregroundColor: textSecondary,
              side: BorderSide(color: borderColor),
              shape: const StadiumBorder(),
            ),
          ),
          if (coverFileName != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              coverFileName!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            key: const Key('songForm_audioPickButton'),
            onPressed: isLoading ? null : onPickAudio,
            icon: const Icon(Icons.audiotrack, size: 14),
            label: Text(isEditing ? 'Thay file audio' : 'Tải file audio *'),
            style: OutlinedButton.styleFrom(
              foregroundColor: textSecondary,
              side: BorderSide(color: borderColor),
              shape: const StadiumBorder(),
            ),
          ),
          if (audioFileName != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              audioFileName!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ] else if (!isEditing) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Bắt buộc khi tạo mới',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.errorLight),
              textAlign: TextAlign.center,
            ),
          ],
          const Spacer(),
          Text(
            'Nguồn dữ liệu artist, genre, album được tải từ API.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: textSecondary, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LyricsCard extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool isLoading;
  final bool isSaving;
  final String? errorText;
  final Future<void> Function()? onReload;
  final Future<void> Function(String text)? onSave;
  final Color borderColor;
  final Color bgCard;
  final Color textPrimary;
  final Color textSecondary;

  const _LyricsCard({
    required this.controller,
    required this.enabled,
    required this.isLoading,
    required this.isSaving,
    required this.errorText,
    required this.onReload,
    required this.onSave,
    required this.borderColor,
    required this.bgCard,
    required this.textPrimary,
    required this.textSecondary,
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
          Row(
            children: [
              Text(
                'Lời bài hát',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: AppSpacing.md),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!enabled)
            Text(
              'Vui lòng lưu bài hát trước khi cập nhật lời bài hát.',
              style: TextStyle(color: textSecondary),
            )
          else ...[
            if (errorText != null)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.errorSurfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.container),
                  border: Border.all(color: AppColors.errorLight),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 18,
                      color: AppColors.errorLight,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.errorLight,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onReload,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            TextField(
              key: const Key('songForm_lyricsField'),
              controller: controller,
              minLines: 7,
              maxLines: 14,
              style: TextStyle(color: textPrimary, height: 1.4),
              decoration: InputDecoration(
                hintText: 'Nhập lời bài hát...',
                hintStyle: TextStyle(
                  color: textPrimary.withValues(alpha: 0.45),
                ),
                filled: true,
                fillColor: bgCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nếu muốn xóa lời bài hát, hãy xóa hết nội dung và bấm Lưu lời bài hát.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                key: const Key('songForm_saveLyricsButton'),
                onPressed: (isSaving || onSave == null)
                    ? null
                    : () => onSave!(controller.text),
                icon: isSaving
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.pureWhite,
                        ),
                      )
                    : const Icon(Icons.save_outlined, size: 16),
                label: const Text('Lưu lời bài hát'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.nearBlack,
                  foregroundColor: AppColors.pureWhite,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
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
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.textColor,
    required this.borderColor,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor)),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          key: key,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
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
