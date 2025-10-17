import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/actors_container.dart';
import '../widgets/actor_tile.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addActor() {
    final actor = _controller.text.trim();
    if (actor.isNotEmpty) {
      ActorsContainer.of(context).addActor(actor);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = ActorsContainer.of(context);
    final actors = container.favoriteActors;

    return Scaffold(
      appBar: AppBar(title: const Text('Любимые актёры')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите имя актёра',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addActor,
              child: const Text('Добавить актёра'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: actors.isEmpty
                  ? const EmptyState(
                icon: Icons.person,
                title: 'Нет любимых актёров',
                subtitle: 'Добавьте актёров в список',
              )
                  : SingleChildScrollView(
                child: Column(
                  children: actors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final actor = entry.value;
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
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
