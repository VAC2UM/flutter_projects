import 'package:flutter/material.dart';
import '../models/actor.dart';

class ActorsContainer extends StatefulWidget {
  final Widget child;

  const ActorsContainer({super.key, required this.child});

  @override
  State<ActorsContainer> createState() => _ActorsContainerState();

  static _ActorsContainerState of(BuildContext context) {
    return context.findAncestorStateOfType<_ActorsContainerState>()!;
  }
}

class _ActorsContainerState extends State<ActorsContainer> {
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
