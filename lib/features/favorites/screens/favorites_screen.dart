import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:flutter_projects/features/favorites/state/favorites_container.dart';
import 'package:flutter_projects/features/favorites/widgets/favorite_tile.dart';
import '../../../shared/theme/theme_state.dart';

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

    final result = await context.push('/favorites/add');

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
        backgroundColor: ThemeState.of(context).currentTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  void _showLimitDialog() {
    final themeState = ThemeState.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Лимит достигнут'),
        content: const Text('Нельзя добавить более 4 фильмов в избранное.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Ок',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);
    final container = FavoritesContainer.of(context);
    final favorites = container.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFavoritesCounter(favorites.length, themeState),
          const SizedBox(height: 20),
          Expanded(
            child: favorites.isEmpty
                ? EmptyState(
              icon: Icons.favorite_border,
              title: 'Нет избранных фильмов',
              subtitle: 'Добавьте фильмы в избранное',
              themeState: themeState,
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
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFavoritesCounter(int count, ThemeState themeState) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeState.currentTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeState.currentTheme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Избранные фильмы:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: themeState.currentTheme.colorScheme.onPrimaryContainer,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: themeState.currentTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$count/4',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.onPrimary,
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