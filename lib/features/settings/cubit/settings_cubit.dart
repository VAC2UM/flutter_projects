import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/settings/state/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    emit(state.copyWith(isLoading: true));

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final initialSettings = SettingsState(
          isDarkMode: false,
          notificationsEnabled: true,
          isLoading: false,
        );

        emit(initialSettings);
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Ошибка загрузки настроек: $e',
        ));
      }
    });
  }

  void toggleTheme() {
    final newDarkMode = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newDarkMode));

    _saveThemePreference(newDarkMode);
  }

  void toggleNotifications() {
    final newNotificationsState = !state.notificationsEnabled;
    emit(state.copyWith(notificationsEnabled: newNotificationsState));

    _saveNotificationsPreference(newNotificationsState);
  }

  void setDarkMode(bool isDarkMode) {
    emit(state.copyWith(isDarkMode: isDarkMode));
    _saveThemePreference(isDarkMode);
  }

  void setNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
    _saveNotificationsPreference(enabled);
  }

  void resetToDefaults() {
    emit(const SettingsState(
      isDarkMode: false,
      notificationsEnabled: true,
    ));

    _saveThemePreference(false);
    _saveNotificationsPreference(true);
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void _saveThemePreference(bool isDarkMode) {
    print('Сохранена тема: ${isDarkMode ? "тёмная" : "светлая"}');
  }

  void _saveNotificationsPreference(bool enabled) {
    print('Уведомления: ${enabled ? "включены" : "выключены"}');
  }
}