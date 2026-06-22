import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:gdvn/app_shell.dart';
import 'package:gdvn/theme/app_theme.dart';

void main() {
  runApp(const GdvnApp());
}

class GdvnApp extends StatefulWidget {
  const GdvnApp({super.key});

  @override
  State<GdvnApp> createState() => _GdvnAppState();
}

class _GdvnAppState extends State<GdvnApp> {
  final AppThemeController _themeController = AppThemeController();

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: _themeController,
        builder: (context, themeMode, _) {
          return WidgetsApp(
            title: 'GDVN',
            color: const Color(0xFF000000),
            pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
              return PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    builder(context),
              );
            },
            builder: (context, child) {
              final brightness = _themeController.effectiveBrightness(
                MediaQuery.maybePlatformBrightnessOf(context) ?? Brightness.light,
              );

              return FTheme(
                data: brightness == Brightness.dark
                    ? FThemes.neutral.dark.touch
                    : FThemes.neutral.light.touch,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
