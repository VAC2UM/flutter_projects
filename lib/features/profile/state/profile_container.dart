import 'package:flutter/material.dart';
import 'package:flutter_projects/features/profile/models/user.dart';

class ProfileContainer extends StatefulWidget {
  final Widget child;

  const ProfileContainer({super.key, required this.child});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();

  static _ProfileContainerState of(BuildContext context) {
    return context.findAncestorStateOfType<_ProfileContainerState>()!;
  }
}

class _ProfileContainerState extends State<ProfileContainer> {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void updateUser(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}