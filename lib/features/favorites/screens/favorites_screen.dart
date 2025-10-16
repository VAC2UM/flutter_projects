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
    final movie = _controller.text.trim();
    if (movie.isNotEmpty) {
      FavoritesContainer.of(context).addFavorite(movie);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: StatefulBuilder(
                builder: (context, setState) {
                  final favorites = FavoritesContainer.of(context).favorites;

                  if (favorites.isEmpty) {
                    return const EmptyState(
                      icon: Icons.favorite,
                      title: 'Нет избранных фильмов',
                      subtitle: 'Добавьте фильмы в избранное',
                    );
                  }

                  return ListView.separated(
                    itemCount: favorites.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey, height: 1),
                    itemBuilder: (context, index) {
                      final favorite = favorites[index];
                      return FavoriteTile(
                        favorite: favorite,
                        onDelete: () {
                          FavoritesContainer.of(context).removeFavorite(index);
                          setState(() {});
                        },
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
