import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/favorites_container.dart';
import '../widgets/favorite_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFavorite() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final container = FavoritesContainer.of(context);
    final favorites = container.favorites;

    if (favorites.length >= 4) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Лимит достигнут'),
          content: const Text('Нельзя добавить более 4 фильмов в избранное.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ок'),
            ),
          ],
        ),
      );
      return;
    }

    container.addFavorite(title);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = FavoritesContainer.of(context);
    final favorites = container.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите название фильма',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addFavorite,
              child: const Text('Добавить в избранное'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: favorites.isEmpty
                  ? const EmptyState(
                icon: Icons.favorite,
                title: 'Нет избранных фильмов',
                subtitle: 'Добавьте фильмы в избранное',
              )
                  : ListView.separated(
                itemCount: favorites.length,
                separatorBuilder: (context, _) =>
                const Divider(color: Colors.grey, height: 1),
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return FavoriteTile(
                    favorite: favorite,
                    onDelete: () {
                      container.deleteFavorite(
                        context,
                        favorite.id,
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
}
