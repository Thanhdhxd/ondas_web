import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ondas_web/app/widgets/admin_shell.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/di/injection.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_bloc.dart';
import 'package:ondas_web/features/artists/presentation/screens/artist_form_screen.dart';
import 'package:ondas_web/features/artists/presentation/screens/artists_screen.dart';
import 'package:ondas_web/features/genres/presentation/bloc/genre_bloc.dart';
import 'package:ondas_web/features/genres/presentation/screens/genre_form_screen.dart';
import 'package:ondas_web/features/genres/presentation/screens/genres_screen.dart';
import 'package:ondas_web/features/lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_bloc.dart';
import 'package:ondas_web/features/playlists/presentation/screens/system_playlist_form_screen.dart';
import 'package:ondas_web/features/playlists/presentation/screens/system_playlists_screen.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_bloc.dart';
import 'package:ondas_web/features/songs/presentation/screens/song_form_screen.dart';
import 'package:ondas_web/features/songs/presentation/screens/songs_screen.dart';
import 'package:ondas_web/features/tags/presentation/bloc/tag_bloc.dart';
import 'package:ondas_web/features/tags/presentation/screens/tag_form_screen.dart';
import 'package:ondas_web/features/tags/presentation/screens/tags_screen.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ondas_web/features/auth/presentation/screens/login_screen.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ondas_web/features/albums/presentation/bloc/album_bloc.dart';
import 'package:ondas_web/features/albums/presentation/screens/album_form_screen.dart';
import 'package:ondas_web/features/albums/presentation/screens/albums_screen.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_bloc.dart';
import 'package:ondas_web/features/users/presentation/screens/admin_users_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppConstants.routeLogin,
    redirect: _guard,
    routes: [
      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(currentRoute: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppConstants.routeDashboard,
            name: 'dashboard',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<DashboardBloc>()..add(const DashboardStarted()),
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppConstants.routeArtists,
            name: 'artists',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<ArtistBloc>(),
              child: const ArtistsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'artistNew',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<ArtistBloc>(),
                  child: const ArtistFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'artistEdit',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<ArtistBloc>(),
                  child: ArtistFormScreen(artistId: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routeSongs,
            name: 'songs',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<SongBloc>(),
              child: const SongsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'songNew',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<SongBloc>()),
                    BlocProvider(create: (_) => sl<LyricsBloc>()),
                  ],
                  child: const SongFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'songEdit',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<SongBloc>()),
                    BlocProvider(create: (_) => sl<LyricsBloc>()),
                  ],
                  child: SongFormScreen(songId: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routeGenres,
            name: 'genres',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<GenreBloc>(),
              child: const GenresScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'genreNew',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<GenreBloc>(),
                  child: const GenreFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'genreEdit',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<GenreBloc>(),
                  child: GenreFormScreen(genreId: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routeTags,
            name: 'tags',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<TagBloc>(),
              child: const TagsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'tagNew',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<TagBloc>(),
                  child: const TagFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'tagEdit',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<TagBloc>(),
                  child: TagFormScreen(tagId: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routePlaylists,
            name: 'systemPlaylists',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<SystemPlaylistBloc>(),
              child: SystemPlaylistsScreen(
                key: ValueKey(state.uri.toString()),
              ),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'systemPlaylistNew',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<SystemPlaylistBloc>(),
                  child: const SystemPlaylistFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'systemPlaylistEdit',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<SystemPlaylistBloc>(),
                  child: SystemPlaylistFormScreen(
                    playlistId: state.pathParameters['id'],
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routeAlbums,
            name: 'albums',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<AlbumBloc>(),
              child: const AlbumsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                name: 'albumNew',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<AlbumBloc>()),
                    BlocProvider(create: (_) => sl<ArtistBloc>()),
                    BlocProvider(create: (_) => sl<SongBloc>()),
                  ],
                  child: const AlbumFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'albumEdit',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<AlbumBloc>()),
                    BlocProvider(create: (_) => sl<ArtistBloc>()),
                    BlocProvider(create: (_) => sl<SongBloc>()),
                  ],
                  child: AlbumFormScreen(albumId: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.routeUsers,
            name: 'users',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<AdminUserBloc>(),
              child: const AdminUsersScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final token = await sl<SecureStorage>().getAccessToken();
  final role = await sl<SecureStorage>().getUserRole();
  final isLoggedIn = token != null && token.isNotEmpty;
  final isOnLogin = state.matchedLocation == AppConstants.routeLogin;
  final isUsersRoute = state.matchedLocation.startsWith(
    AppConstants.routeUsers,
  );

  if (!isLoggedIn && !isOnLogin) return AppConstants.routeLogin;
  if (isLoggedIn && isOnLogin) return AppConstants.routeDashboard;
  if (isUsersRoute && role != AppConstants.roleAdmin) {
    return AppConstants.routeDashboard;
  }
  return null;
}

// ─── Error screen ─────────────────────────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page not found: ${error?.toString() ?? ''}')),
    );
  }
}
