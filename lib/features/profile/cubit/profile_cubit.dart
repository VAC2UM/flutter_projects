import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/profile/state/profile_state.dart';
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

    emit(state.copyWith(user: updatedUser));
  }
}
