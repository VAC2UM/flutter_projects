import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';
import '../../../../shared/data/preferences_helper.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    emit(state.copyWith(isLoading: true));

    try {
      final isDarkMode = await PreferencesHelper.getDarkMode();
      final notificationsEnabled =
          await PreferencesHelper.getNotificationsEnabled();

      final loadedSettings = SettingsState(
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        isLoading: false,
      );

      emit(loadedSettings);
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Ошибка загрузки настроек: $e'),
      );
    }
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
    emit(const SettingsState(isDarkMode: false, notificationsEnabled: true));

    _saveThemePreference(false);
    _saveNotificationsPreference(true);
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    try {
      await PreferencesHelper.setDarkMode(isDarkMode);
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка сохранения темы: $e'));
    }
  }

  Future<void> _saveNotificationsPreference(bool enabled) async {
    try {
      await PreferencesHelper.setNotificationsEnabled(enabled);
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка сохранения настроек уведомлений: $e'));
    }
  }
}
