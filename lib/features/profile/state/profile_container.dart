import 'package:flutter/material.dart';
import '../models/actor.dart';

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
  final List<Actor> _favoriteActors = [];

  List<Actor> get favoriteActors => List.unmodifiable(_favoriteActors);

  void addActor(String name) {
    setState(() {
      _favoriteActors.add(Actor.create(name: name));
    });
  }

  void removeActor(int index) {
    setState(() {
      _favoriteActors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
