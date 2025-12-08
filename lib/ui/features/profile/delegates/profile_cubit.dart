import 'package:flutter_bloc/flutter_bloc.dart';
import '../delegates/profile_state.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(isLoading: true)) {
    loadUserData();
  }

  void loadUserData() {
    try {
      if (locator.isRegistered<AppData>()) {
        final appData = locator<AppData>();
        final user = appData.currentUser;
        emit(ProfileState(user: user, isLoading: false));
      } else {
        emit(const ProfileState(isLoading: false, error: 'Данные не найдены'));
      }
    } catch (e) {
      emit(ProfileState(isLoading: false, error: 'Ошибка загрузки: $e'));
    }
  }

  void updateProfile({String? name, String? email, String? avatarUrl}) {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );

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
