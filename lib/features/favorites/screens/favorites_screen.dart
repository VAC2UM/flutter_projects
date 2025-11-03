import 'package:flutter/material.dart';
import 'package:flutter_projects/features/favorites/screens/add_favorite_screen.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:flutter_projects/features/favorites/state/favorites_container.dart';
import 'package:flutter_projects/features/favorites/widgets/favorite_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _openAddFavoriteForm() async {
    final container = FavoritesContainer.of(context);
    if (container.favorites.length >= 4) {
      _showLimitDialog();
      return;
    }

    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddFavoriteScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      _addFavoriteFromForm(result);
    }
  }

  void _addFavoriteFromForm(Map<String, dynamic> favoriteData) {
    final container = FavoritesContainer.of(context);

    container.addFavorite(
      title: favoriteData['title'],
      imageUrl: favoriteData['imageUrl'].isEmpty ? null : favoriteData['imageUrl'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${favoriteData['title']}" добавлен в избранное'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  void _showLimitDialog() {
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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: Column(
        children: [
          _buildFavoritesCounter(favorites.length),
          const SizedBox(height: 20),
          Expanded(
            child: favorites.isEmpty
                ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'Нет избранных фильмов',
              subtitle: 'Добавьте фильмы в избранное',
            )
                : ListView.separated(
              padding: const EdgeInsets.all(20.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddFavoriteForm,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFavoritesCounter(int count) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
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