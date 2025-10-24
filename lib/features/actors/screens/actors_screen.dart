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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addActor() {
    final name = _nameController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (name.isNotEmpty) {
      ActorsContainer.of(context).addActor(
        name: name,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      _nameController.clear();
      _imageUrlController.clear();
      setState(() {});
    }
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildAddActorForm(),
            const SizedBox(height: 20),
            Expanded(
              child: actors.isEmpty
                  ? const EmptyState(
                icon: Icons.person,
                title: 'Нет любимых актёров',
                subtitle: 'Добавьте актёров в список',
              )
                  : ListView.separated(
                itemCount: actors.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 8),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddActorForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Имя актёра',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _imageUrlController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'URL фото (опционально)',
            prefixIcon: Icon(Icons.image),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addActor,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Добавить актёра'),
        ),
      ],
    );
  }
}