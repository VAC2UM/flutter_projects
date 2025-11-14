import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/features/profile/models/user.dart';

@immutable
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileState &&
        other.user == user &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isEditing == isEditing;
  }

  @override
  int get hashCode => Object.hash(user, isLoading, error, isEditing);
}