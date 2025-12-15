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

      final loadedSettings = SettingsState(
        isDarkMode: isDarkMode,
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

  void setDarkMode(bool isDarkMode) {
    emit(state.copyWith(isDarkMode: isDarkMode));
    _saveThemePreference(isDarkMode);
  }

  void resetToDefaults() {
    emit(const SettingsState(isDarkMode: false));

    _saveThemePreference(false);
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
}
