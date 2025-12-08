import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _checkInitialAuth();
  }

  void _checkInitialAuth() {
    try {
      if (locator.isRegistered<AppStateService>()) {
        final appState = locator<AppStateService>();
        final currentUser = appState.currentUser;
        if (currentUser.isNotEmpty) {
          emit(AuthState(isAuthenticated: true, currentUser: currentUser));
        }
      }
    } catch (e) {
      emit(AuthState(error: 'Ошибка проверки авторизации: $e'));
    }
  }

  void login(String login, String password) {
    emit(state.copyWith(isLoading: true, error: null));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (login == 'admin' && password == '12345') {
        if (locator.isRegistered<AppStateService>()) {
          final appState = locator<AppStateService>();
          appState.setCurrentUser(login);
        }

        emit(
          AuthState(
            isAuthenticated: true,
            currentUser: login,
            isLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(isLoading: false, error: 'Неверный логин или пароль'),
        );
      }
    });
  }

  void logout() {
    if (locator.isRegistered<AppStateService>()) {
      final appState = locator<AppStateService>();
      appState.setCurrentUser('');
    }

    emit(const AuthState(isAuthenticated: false, currentUser: null));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
