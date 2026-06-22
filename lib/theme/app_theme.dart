import 'package:flutter/widgets.dart';

enum AppThemeMode {
  system,
  dark,
  light,
}

class AppThemeController extends ValueNotifier<AppThemeMode> {
  AppThemeController([super.value = AppThemeMode.system]);

  Brightness effectiveBrightness(Brightness platformBrightness) {
    return switch (value) {
      AppThemeMode.system => platformBrightness,
      AppThemeMode.dark => Brightness.dark,
      AppThemeMode.light => Brightness.light,
    };
  }
}

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({required AppThemeController controller, required super.child, super.key})
    : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'No AppThemeScope found in context.');
    return scope!.notifier!;
  }
}