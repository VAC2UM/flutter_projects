import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/watchlist/models/watchlist_item.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_state.dart';
import 'package:flutter_projects/features/watchlist/widgets/watchlist_item_tile.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchlistCubit(),
      child: const WatchlistView(),
    );
  }
}

class WatchlistView extends StatelessWidget {
  const WatchlistView({super.key});

  void _openAddWatchlistForm(BuildContext context) async {
    final cubit = context.read<WatchlistCubit>();
    final state = cubit.state;

    if (state.isLimitReached) {
      _showLimitDialog(context);
      return;
    }

    final result = await context.push(
      '/watchlist/add',
      extra: cubit,
    );

    if (result != null && result is Map<String, dynamic>) {
      cubit.addItem(
        title: result['title'],
        imageUrl: result['imageUrl'].isEmpty ? null : result['imageUrl'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${result['title']}" добавлен в список желаемого'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLimitDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    final maxItems = context.read<WatchlistCubit>().state.maxItems;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Лимит достигнут'),
        content: Text('Нельзя добавить более $maxItems фильмов в список желаемого.'),
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

  void _deleteItemWithUndo(BuildContext context, WatchlistItem item) {
    final cubit = context.read<WatchlistCubit>();
    final originalIndex = cubit.state.items.indexOf(item);

    cubit.deleteItem(item.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён из списка желаемого: ${item.title}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            // Для восстановления нужно будет добавить метод restoreItem в Cubit
            context.read<WatchlistCubit>().addItem(
              title: item.title,
              imageUrl: item.imageUrl,
            );
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
        title: const Text('Желаемое'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<WatchlistCubit, WatchlistState>(
            builder: (context, state) {
              if (state.items.isNotEmpty) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear_all') {
                      _showClearAllDialog(context);
                    } else if (value == 'clear_watched') {
                      _showClearWatchedDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear_watched',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Очистить просмотренные'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep, size: 20),
                          SizedBox(width: 8),
                          Text('Очистить все'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
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
                      context.read<WatchlistCubit>().clearError();
                      context.read<WatchlistCubit>().loadWatchlist();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildStatistics(state, themeState),
              const SizedBox(height: 20),
              Expanded(
                child: state.items.isEmpty
                    ? EmptyState(
                  icon: Icons.list,
                  title: 'Список пуст',
                  subtitle: 'Добавьте фильмы, которые хотите посмотреть',
                  themeState: themeState,
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: state.items.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return WatchlistItemTile(
                      item: item,
                      onChanged: (watched) {
                        context.read<WatchlistCubit>().toggleWatched(item.id);
                      },
                      onDelete: () => _deleteItemWithUndo(context, item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddWatchlistForm(context),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics(WatchlistState state, ThemeState themeState) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeState.currentTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeState.currentTheme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Всего', state.itemsCount.toString(), Icons.movie, themeState),
          _buildStatItem('Просмотрено', state.watchedCount.toString(), Icons.check_circle, themeState),
          _buildStatItem('Осталось', state.remainingCount.toString(), Icons.schedule, themeState),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeState themeState) {
    return Column(
      children: [
        Icon(
          icon,
          color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    final cubit = context.read<WatchlistCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить все'),
        content: const Text('Вы уверены, что хотите удалить все фильмы из списка желаемого?'),
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
              cubit.clearAllItems();
              context.pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Все фильмы удалены из списка желаемого'),
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

  void _showClearWatchedDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    final cubit = context.read<WatchlistCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить просмотренные'),
        content: const Text('Вы уверены, что хотите удалить все просмотренные фильмы?'),
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
              cubit.clearWatchedItems();
              context.pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Просмотренные фильмы удалены'),
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