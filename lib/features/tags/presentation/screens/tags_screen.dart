import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_bloc.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_event.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_state.dart';
import 'package:ondas_web/features/tags/presentation/widgets/tag_table_widget.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  String? _type;
  static const int _pageSize = AppConstants.defaultPageSize;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    final query = _searchController.text.trim();
    context.read<TagBloc>().add(
      TagLoadListEvent(
        page: _currentPage,
        size: _pageSize,
        query: query.isEmpty ? null : query,
        type: _type,
      ),
    );
  }

  void _onSearch(String query) {
    setState(() => _currentPage = 0);
    _load();
  }

  void _onTypeChanged(String? type) {
    setState(() {
      _type = type;
      _currentPage = 0;
    });
    _load();
  }

  Future<void> _onAdd() async {
    final result = await context.push<bool>('${AppConstants.routeTags}/new');
    if (result == true && mounted) _load();
  }

  Future<void> _onEdit(Tag tag) async {
    final result = await context.push<bool>(
      '${AppConstants.routeTags}/${tag.id}/edit',
    );
    if (result == true && mounted) _load();
  }

  void _onDelete(Tag tag) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${tag.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.pureWhite,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TagBloc>().add(TagDeleteEvent(id: tag.id));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TagBloc, TagState>(
      listener: (context, state) {
        if (state is TagOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.successLight,
            ),
          );
          _load();
        } else if (state is TagOperationError || state is TagListError) {
          final message = state is TagOperationError
              ? state.message
              : (state as TagListError).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.errorLight,
            ),
          );
        }
      },
      child: _TagsContent(
        searchController: _searchController,
        currentPage: _currentPage,
        selectedType: _type,
        onSearch: _onSearch,
        onTypeChanged: _onTypeChanged,
        onPageChanged: (page) {
          setState(() => _currentPage = page);
          _load();
        },
        onAdd: _onAdd,
        onEdit: _onEdit,
        onDelete: _onDelete,
      ),
    );
  }
}

class _TagsContent extends StatelessWidget {
  final TextEditingController searchController;
  final int currentPage;
  final String? selectedType;
  final void Function(String) onSearch;
  final void Function(String?) onTypeChanged;
  final void Function(int) onPageChanged;
  final VoidCallback onAdd;
  final void Function(Tag) onEdit;
  final void Function(Tag) onDelete;

  const _TagsContent({
    required this.searchController,
    required this.currentPage,
    required this.selectedType,
    required this.onSearch,
    required this.onTypeChanged,
    required this.onPageChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;

    return BlocBuilder<TagBloc, TagState>(
      builder: (context, state) {
        final tags = state is TagListLoaded ? state.tags : <Tag>[];
        final totalPages = state is TagListLoaded ? state.totalPages : 1;
        final totalElements = state is TagListLoaded ? state.totalElements : 0;
        final isLoading =
            state is TagListLoading || state is TagOperationInProgress;

        return Container(
          color: bgColor,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tags',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$totalElements items',
                        style: TextStyle(color: textSecondary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Thêm tag'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Tìm tag...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                      onSubmitted: onSearch,
                      onChanged: (value) {
                        if (value.isEmpty) onSearch('');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'all', label: Text('All')),
                      ButtonSegment(value: 'mood', label: Text('Mood')),
                      ButtonSegment(value: 'theme', label: Text('Theme')),
                      ButtonSegment(value: 'activity', label: Text('Activity')),
                      ButtonSegment(value: 'era', label: Text('Era')),
                    ],
                    selected: {selectedType ?? 'all'},
                    onSelectionChanged: (value) {
                      final selected = value.first;
                      onTypeChanged(selected == 'all' ? null : selected);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TagTableWidget(
                        tags: tags,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      ),
              ),
              if (totalPages > 1) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 0
                          ? () => onPageChanged(currentPage - 1)
                          : null,
                    ),
                    Text('Trang ${currentPage + 1} / $totalPages'),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages - 1
                          ? () => onPageChanged(currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
