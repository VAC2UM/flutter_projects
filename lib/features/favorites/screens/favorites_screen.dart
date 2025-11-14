import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/favorites/favorites_feature.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/favorites/cubit/favorites_cubit.dart';
import 'package:flutter_projects/features/favorites/state/favorites_state.dart';
import 'package:flutter_projects/features/favorites/widgets/favorite_tile.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesCubit(),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  void _openAddFavoriteForm(BuildContext context) async {
    final cubit = context.read<FavoritesCubit>();
    final state = cubit.state;

    if (state.isLimitReached) {
      _showLimitDialog(context);
      return;
    }

    final result = await context.push(
      '/favorites/add',
      extra: cubit,
    );

    if (result != null && result is Map<String, dynamic>) {
      cubit.addFavorite(
        title: result['title'],
        imageUrl: result['imageUrl'].isEmpty ? null : result['imageUrl'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${result['title']}" добавлен в избранное'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLimitDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    final maxFavorites = context.read<FavoritesCubit>().state.maxFavorites;

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

  void _deleteFavoriteWithUndo(BuildContext context, Favorite favorite) {
    final cubit = context.read<FavoritesCubit>();
    final originalIndex = cubit.state.favorites.indexOf(favorite);

    cubit.deleteFavorite(favorite.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён из избранного: ${favorite.title}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            cubit.restoreFavorite(favorite, originalIndex);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (state.favorites.isNotEmpty) {
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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
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
                      state.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeState.currentTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().clearError();
                      context.read<FavoritesCubit>().loadFavorites();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

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
                      onDelete: () => _deleteFavoriteWithUndo(context, favorite),
                    );
                  },
                ),
              ),
            ],
          );
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

  Widget _buildFavoritesCounter(FavoritesState state, ThemeState themeState) {
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
    final cubit = context.read<FavoritesCubit>();

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
              cubit.clearAllFavorites();
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