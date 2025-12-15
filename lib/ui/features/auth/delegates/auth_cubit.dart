import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:flutter_projects/shared/data/secure_storage_helper.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    try {
      final token = await SecureStorageHelper.getAuthToken();

      if (token != null && token.isNotEmpty) {
        final savedUser = token;

        if (locator.isRegistered<AppStateService>()) {
          final appState = locator<AppStateService>();
          appState.setCurrentUser(savedUser);
        }

        emit(AuthState(isAuthenticated: true, currentUser: savedUser));
      } else {
        if (locator.isRegistered<AppStateService>()) {
          final appState = locator<AppStateService>();
          final currentUser = appState.currentUser;
          if (currentUser.isNotEmpty) {
            emit(AuthState(isAuthenticated: true, currentUser: currentUser));
          }
        }
      }
    } catch (e) {
      emit(AuthState(error: 'Ошибка проверки авторизации: $e'));
    }
  }

  void login(String login, String password) {
    emit(state.copyWith(isLoading: true, error: null));

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (login == 'admin' && password == '12345') {
        // Генерируем простой токен (в реальном приложении это будет JWT от сервера)
        final token = 'token_${login}_${DateTime.now().millisecondsSinceEpoch}';
        
        // Сохраняем токен в Secure Storage
        await SecureStorageHelper.saveAuthToken(token);

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

  Future<void> logout() async {
    // Удаляем токен из Secure Storage
    await SecureStorageHelper.deleteAuthToken();

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
