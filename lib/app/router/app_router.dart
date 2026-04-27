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
import 'package:ondas_web/features/songs/presentation/bloc/song_bloc.dart';
import 'package:ondas_web/features/songs/presentation/screens/song_form_screen.dart';
import 'package:ondas_web/features/songs/presentation/screens/songs_screen.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ondas_web/features/auth/presentation/screens/login_screen.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ondas_web/features/albums/presentation/bloc/album_bloc.dart';
import 'package:ondas_web/features/albums/presentation/screens/album_form_screen.dart';
import 'package:ondas_web/features/albums/presentation/screens/albums_screen.dart';

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
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<SongBloc>(),
                  child: const SongFormScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'songEdit',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<SongBloc>(),
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
        ],
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final token = await sl<SecureStorage>().getAccessToken();
  final isLoggedIn = token != null && token.isNotEmpty;
  final isOnLogin = state.matchedLocation == AppConstants.routeLogin;

  if (!isLoggedIn && !isOnLogin) return AppConstants.routeLogin;
  if (isLoggedIn && isOnLogin) return AppConstants.routeDashboard;
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
