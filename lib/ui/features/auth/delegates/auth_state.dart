// features/auth/state/auth_state.dart
import 'package:flutter/cupertino.dart';

@immutable
class AuthState {
  final bool isAuthenticated;
  final String? currentUser;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isAuthenticated == isAuthenticated &&
        other.currentUser == currentUser &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(isAuthenticated, currentUser, isLoading, error);
}