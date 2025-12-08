import 'package:flutter/material.dart';
import 'package:flutter_projects/ui/shared/app_theme.dart';

class ThemeState extends InheritedWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ThemeState({
    super.key,
    required super.child,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  static ThemeState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeState>();
    assert(result != null, 'No ThemeState found in context');
    return result!;
  }

  ThemeData get currentTheme =>
      isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  @override
  bool updateShouldNotify(ThemeState oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}
