import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/wp_config.dart';
import 'core/localization/app_locales.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/theme_constants.dart';
import 'core/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  AppUtil.setDisplayToHighRefreshRate();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocales.english,
      child: ProviderScope(
        child: NewsProApp(savedThemeMode: savedThemeMode),
      ),
    ),
  );
}

class NewsProApp extends StatelessWidget {
  const NewsProApp({Key? key, this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: WPConfig.appName,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: theme,
        darkTheme: darkTheme,
        onGenerateRoute: RouteGenerator.onGenerate,
        initialRoute: AppRoutes.initial,
        onUnknownRoute: (_) => RouteGenerator.errorRoute(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
