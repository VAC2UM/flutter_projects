import 'package:flutter_bloc/flutter_bloc.dart';
import '../delegates/profile_state.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/data/preferences_helper.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(isLoading: true)) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final savedUser = await PreferencesHelper.getUserProfile();

      if (savedUser != null) {
        if (locator.isRegistered<AppData>()) {
          final appData = locator<AppData>();
          final updatedAppData = appData.updateUserProfile(savedUser);
          locator.unregister<AppData>();
          locator.registerSingleton<AppData>(updatedAppData);
        }
        emit(ProfileState(user: savedUser, isLoading: false));
      } else if (locator.isRegistered<AppData>()) {
        final appData = locator<AppData>();
        final user = appData.currentUser;
        await PreferencesHelper.saveUserProfile(user);
        emit(ProfileState(user: user, isLoading: false));
      } else {
        emit(const ProfileState(isLoading: false, error: 'Данные не найдены'));
      }
    } catch (e) {
      emit(ProfileState(isLoading: false, error: 'Ошибка загрузки: $e'));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );

    // Сохраняем в SharedPreferences
    try {
      await PreferencesHelper.saveUserProfile(updatedUser);
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка сохранения профиля: $e'));
      return;
    }

    // Обновляем AppData (создаем новый экземпляр с обновленным пользователем)
    try {
      if (locator.isRegistered<AppData>()) {
        final appData = locator<AppData>();
        final updatedAppData = appData.updateUserProfile(updatedUser);
        // Обновляем зарегистрированный экземпляр через реестр
        locator.unregister<AppData>();
        locator.registerSingleton<AppData>(updatedAppData);
      }
    } catch (e) {
      // Если не удалось обновить AppData, продолжаем без ошибки
      print('Ошибка обновления AppData: $e');
    }

    emit(state.copyWith(user: updatedUser));
  }
}
