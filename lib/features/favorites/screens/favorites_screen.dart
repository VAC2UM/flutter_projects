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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addFavorite() {
    final title = _titleController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

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

    container.addFavorite(
      title: title,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
    );
    _titleController.clear();
    _imageUrlController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = FavoritesContainer.of(context);
    final favorites = container.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Форма добавления в избранное
            _buildAddFavoriteForm(),
            const SizedBox(height: 20),
            // Счетчик избранных фильмов
            _buildFavoritesCounter(favorites.length),
            const SizedBox(height: 20),
            // Список избранных
            Expanded(
              child: favorites.isEmpty
                  ? const EmptyState(
                icon: Icons.favorite_border,
                title: 'Нет избранных фильмов',
                subtitle: 'Добавьте фильмы в избранное',
              )
                  : ListView.separated(
                itemCount: favorites.length,
                separatorBuilder: (context, _) => const SizedBox(height: 8),
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

  Widget _buildAddFavoriteForm() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Название фильма',
            prefixIcon: Icon(Icons.movie),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _imageUrlController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'URL постера (опционально)',
            prefixIcon: Icon(Icons.image),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addFavorite,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Добавить в избранное'),
        ),
      ],
    );
  }

  Widget _buildFavoritesCounter(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Избранные фильмы:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.orange[800],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$count/4',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}