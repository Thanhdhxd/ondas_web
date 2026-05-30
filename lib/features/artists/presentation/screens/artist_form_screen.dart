import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_bloc.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_event.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_state.dart';
import 'package:ondas_web/features/artists/presentation/widgets/artist_form_widget.dart';

class ArtistFormScreen extends StatefulWidget {
  final String? artistId;

  const ArtistFormScreen({super.key, this.artistId});

  bool get isEditing => artistId != null;

  @override
  State<ArtistFormScreen> createState() => _ArtistFormScreenState();
}

class _ArtistFormScreenState extends State<ArtistFormScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      context
          .read<ArtistBloc>()
          .add(ArtistLoadDetailEvent(id: widget.artistId!));
    }
  }

  void _onSubmit({
    required String name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  }) {
    if (widget.isEditing) {
      context.read<ArtistBloc>().add(
            ArtistUpdateEvent(
              id: widget.artistId!,
              name: name,
              slug: slug,
              bio: bio,
              country: country,
              avatarBytes: avatarBytes,
              avatarFileName: avatarFileName,
            ),
          );
    } else {
      context.read<ArtistBloc>().add(
            ArtistCreateEvent(
              name: name,
              slug: slug,
              bio: bio,
              country: country,
              avatarBytes: avatarBytes,
              avatarFileName: avatarFileName,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary =
        isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;

    return BlocListener<ArtistBloc, ArtistState>(
      listener: (context, state) {
        final locale = context.read<LocaleCubit>().state.locale;
        if (state is ArtistOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.successLight,
            ),
          );
          context.pop(true);
        } else if (state is ArtistOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.errorLight,
            ),
          );
        }
      },
      child: ColoredBox(
        color: bgColor,
        child: BlocBuilder<ArtistBloc, ArtistState>(
          builder: (context, state) {
            final isOperationLoading = state is ArtistOperationInProgress;
            final isDetailLoading = state is ArtistDetailLoading;

            Artist? initialArtist;
            if (state is ArtistDetailLoaded) {
              initialArtist = state.artist;
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
                        key: const Key('artistForm_backButton'),
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                        color: textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        widget.isEditing
                            ? AppStrings.t(AppStrings.editArtist, context.watch<LocaleCubit>().state.locale)
                            : AppStrings.t(AppStrings.createArtist, context.watch<LocaleCubit>().state.locale),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
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
                    ArtistFormWidget(
                      key: ValueKey(initialArtist?.id ?? 'new'),
                      initialArtist: initialArtist,
                      isLoading: isOperationLoading,
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
