import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool isDarkMode;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.isDarkMode = false,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.isDarkMode == isDarkMode &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(isDarkMode, isLoading, error);
}