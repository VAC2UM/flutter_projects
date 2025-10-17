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

  void deleteActor(BuildContext context, String id, VoidCallback onUpdated) {
    final index = _favoriteActors.indexWhere((actor) => actor.id == id);
    if (index == -1) return;

    final removedActor = _favoriteActors[index];
    setState(() {
      _favoriteActors.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён актёр: ${removedActor.name}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            _restoreActor(removedActor, index);
            onUpdated();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    onUpdated();
  }

  void _restoreActor(Actor actor, int index) {
    setState(() {
      _favoriteActors.insert(index, actor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
