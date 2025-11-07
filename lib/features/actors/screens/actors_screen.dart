import 'package:flutter/material.dart';
import 'package:flutter_projects/features/actors/actors_feature.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/di/service_locator.dart';
import '../../../shared/widgets/empty_state.dart';
import '../widgets/actor_tile.dart';
import '../../../shared/theme/theme_state.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    List<Actor> actors = [];
    if (locator.isRegistered<AppData>()) {
      final appData = locator<AppData>();
      actors = appData.actors;
    } else {
      print('Ошибка: AppData не зарегистрирован в GetIt!');
    }

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
      body: actors.isEmpty
          ? EmptyState(
        icon: Icons.person,
        title: 'Список актеров пуст',
        subtitle: 'Необходимо добавить актеров',
        themeState: themeState,
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: actors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final actor = actors[index];
          return ActorTile(actor: actor);
        },
      ),
    );
  }
}