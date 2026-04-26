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
import 'package:ondas_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ondas_web/features/auth/presentation/screens/login_screen.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/screens/dashboard_screen.dart';

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
        builder: (context, state, child) => AdminShell(
          currentRoute: state.matchedLocation,
          child: child,
        ),
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
                  child: ArtistFormScreen(
                    artistId: state.pathParameters['id'],
                  ),
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
      body: Center(
        child: Text('Page not found: ${error?.toString() ?? ''}'),
      ),
    );
  }
}
