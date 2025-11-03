class AuthState {
  static bool isAuth = false;
  static String currentUser = '';

  static void login(String username) {
    isAuth = true;
    currentUser = username;
  }

  static void logout() {
    isAuth = false;
    currentUser = '';
  }

  static bool get isAuthenticated => isAuth;
}