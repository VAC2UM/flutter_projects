import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/favorites_bloc.dart';
import '../delegates/favorites_event.dart';
import '../delegates/favorites_state.dart';
import '../widgets/favorite_tile.dart';
import 'package:flutter_projects/ui/shared/empty_state.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: 'Очистить все',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: themeState.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeState.currentTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(LoadFavorites());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is FavoritesLoaded) {
            return Column(
              children: [
                _buildFavoritesCounter(state, themeState),
                const SizedBox(height: 20),
                Expanded(
                  child: state.favorites.isEmpty
                      ? EmptyState(
                          icon: Icons.favorite_border,
                          title: 'Нет избранных фильмов',
                          subtitle: 'Добавьте фильмы в избранное',
                          themeState: themeState,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20.0),
                          itemCount: state.favorites.length,
                          separatorBuilder: (context, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final favorite = state.favorites[index];
                            return FavoriteTile(
                              favorite: favorite,
                              onDelete: () => _deleteFavorite(context, favorite),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddFavoriteForm(context),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddFavoriteForm(BuildContext context) {
    final state = context.read<FavoritesBloc>().state;
    if (state is FavoritesLoaded && state.isLimitReached) {
      _showLimitDialog(context, state.maxFavorites);
      return;
    }

    context.push('/favorites/add');
  }

  void _showLimitDialog(BuildContext context, int maxFavorites) {
    final themeState = ThemeState.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Лимит достигнут'),
        content: Text('Нельзя добавить более $maxFavorites фильмов в избранное.'),
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

  void _deleteFavorite(BuildContext context, favorite) {
    context.read<FavoritesBloc>().add(DeleteFavoriteEvent(favorite.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён из избранного: ${favorite.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFavoritesCounter(FavoritesLoaded state, ThemeState themeState) {
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
              color: state.isLimitReached
                  ? themeState.currentTheme.colorScheme.error
                  : themeState.currentTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${state.favoritesCount}/${state.maxFavorites}',
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

  void _showClearAllDialog(BuildContext context) {
    final themeState = ThemeState.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить все'),
        content: const Text('Вы уверены, что хотите удалить все избранные фильмы?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesBloc>().add(ClearAllFavorites());
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Все избранные фильмы удалены'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Очистить',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
