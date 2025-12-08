import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/watchlist_bloc.dart';
import '../delegates/watchlist_event.dart';
import '../delegates/watchlist_state.dart';
import '../widgets/watchlist_item_tile.dart';
import 'package:flutter_projects/ui/shared/empty_state.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

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
          BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              if (state is WatchlistLoaded && state.items.isNotEmpty) {
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
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WatchlistError) {
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
                      context.read<WatchlistBloc>().add(LoadWatchlist());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is WatchlistLoaded) {
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
                                context.read<WatchlistBloc>().add(ToggleWatchedEvent(item.id));
                              },
                              onDelete: () => _deleteItem(context, item),
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
        onPressed: () => _openAddWatchlistForm(context),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddWatchlistForm(BuildContext context) {
    final state = context.read<WatchlistBloc>().state;
    if (state is WatchlistLoaded && state.isLimitReached) {
      _showLimitDialog(context, state.maxItems);
      return;
    }
    context.push('/watchlist/add');
  }

  void _showLimitDialog(BuildContext context, int maxItems) {
    final themeState = ThemeState.of(context);
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
              style: TextStyle(color: themeState.currentTheme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, item) {
    context.read<WatchlistBloc>().add(DeleteWatchlistItemEvent(item.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён из списка желаемого: ${item.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildStatistics(WatchlistLoaded state, ThemeState themeState) {
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
        Icon(icon, color: themeState.currentTheme.colorScheme.onPrimaryContainer, size: 24),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeState.currentTheme.colorScheme.onPrimaryContainer)),
        Text(label, style: TextStyle(fontSize: 12, color: themeState.currentTheme.colorScheme.onPrimaryContainer.withOpacity(0.8))),
      ],
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить все'),
        content: const Text('Вы уверены, что хотите удалить все фильмы из списка желаемого?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('Отмена', style: TextStyle(color: themeState.currentTheme.colorScheme.onSurface))),
          TextButton(
            onPressed: () {
              context.read<WatchlistBloc>().add(ClearAllWatchlistItems());
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Все фильмы удалены из списка желаемого'), duration: Duration(seconds: 2)));
            },
            child: Text('Очистить', style: TextStyle(color: themeState.currentTheme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _showClearWatchedDialog(BuildContext context) {
    final themeState = ThemeState.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить просмотренные'),
        content: const Text('Вы уверены, что хотите удалить все просмотренные фильмы?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('Отмена', style: TextStyle(color: themeState.currentTheme.colorScheme.onSurface))),
          TextButton(
            onPressed: () {
              context.read<WatchlistBloc>().add(ClearWatchedItems());
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Просмотренные фильмы удалены'), duration: Duration(seconds: 2)));
            },
            child: Text('Очистить', style: TextStyle(color: themeState.currentTheme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
