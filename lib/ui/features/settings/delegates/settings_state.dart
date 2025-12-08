import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.isDarkMode == isDarkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(isDarkMode, notificationsEnabled, isLoading, error);
}