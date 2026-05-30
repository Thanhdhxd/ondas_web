import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/di/injection.dart';
import 'package:ondas_web/core/theme/app_theme.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/app/localization/locale_state.dart';
import 'package:ondas_web/app/router/app_router.dart';

class OndasApp extends StatefulWidget {
  const OndasApp({super.key});

  @override
  State<OndasApp> createState() => _OndasAppState();
}

class _OndasAppState extends State<OndasApp> {
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (_) => sl<LocaleCubit>()..init(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            locale: localeState.locale,
            supportedLocales: const [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
