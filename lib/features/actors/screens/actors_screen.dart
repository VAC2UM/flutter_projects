import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/actors_container.dart';
import '../widgets/actor_tile.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  void _openAddActorForm() async {
    final result = await context.push('/actors/add');

    if (result != null && result is Map<String, dynamic>) {
      _addActorFromForm(result);
    }
  }

  void _addActorFromForm(Map<String, dynamic> actorData) {
    final container = ActorsContainer.of(context);

    container.addActor(
      name: actorData['name'],
      imageUrl: actorData['imageUrl'].isEmpty ? null : actorData['imageUrl'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Актер "${actorData['name']}" добавлен'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = ActorsContainer.of(context);
    final actors = container.favoriteActors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Любимые актёры'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: actors.isEmpty
          ? const EmptyState(
        icon: Icons.person,
        title: 'Нет любимых актёров',
        subtitle: 'Добавьте актёров в список',
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: actors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final actor = actors[index];
          return ActorTile(
            actor: actor,
            onDelete: () {
              container.deleteActor(
                context,
                actor.id,
                    () => setState(() {}),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddActorForm,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}