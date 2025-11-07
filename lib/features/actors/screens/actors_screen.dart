import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/actors/actors_feature.dart';
import '../../../shared/widgets/empty_state.dart';
import '../widgets/actor_tile.dart';
import '../../../shared/theme/theme_state.dart';

class ActorsScreen extends StatefulWidget {
  final List<Actor> actors;

  const ActorsScreen({super.key, required this.actors});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Актёры'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: widget.actors.isEmpty
          ? EmptyState(
        icon: Icons.person,
        title: 'Список актеров пуст',
        subtitle: 'Необходимо добавить актеров',
        themeState: themeState,
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: widget.actors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final actor = widget.actors[index];
          return ActorTile(actor: actor);
        },
      ),
    );
  }
}