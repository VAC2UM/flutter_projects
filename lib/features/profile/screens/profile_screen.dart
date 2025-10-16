import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/profile_container.dart';
import '../widgets/actor_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addActor() {
    final actor = _controller.text.trim();
    if (actor.isNotEmpty) {
      ProfileContainer.of(context).addActor(actor);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: StatefulBuilder(
                builder: (context, setState) {
                  final actors = ProfileContainer.of(context).favoriteActors;

                  if (actors.isEmpty) {
                    return const EmptyState(
                      icon: Icons.person,
                      title: 'Нет любимых актёров',
                      subtitle: 'Добавьте актёров в список',
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: actors.asMap().entries.map((entry) {
                        final index = entry.key;
                        final actor = entry.value;
                        return ActorTile(
                          actor: actor,
                          onDelete: () {
                            ProfileContainer.of(context).removeActor(index);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
