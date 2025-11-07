import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_container.dart';
import 'package:flutter_projects/features/watchlist/widgets/watchlist_item_tile.dart';
import '../../../shared/theme/theme_state.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  void _openAddMovieForm() async {
    final result = await context.push('/watchlist/add');

    if (result != null && result is Map<String, dynamic>) {
      _addMovieFromForm(result);
    }
  }

  void _addMovieFromForm(Map<String, dynamic> movieData) {
    final container = WatchlistContainer.of(context);

    container.addMovie(
      title: movieData['title'],
      imageUrl: movieData['imageUrl'].isEmpty ? null : movieData['imageUrl'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${movieData['title']}" добавлен в список'),
        backgroundColor: ThemeState.of(context).currentTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);
    final container = WatchlistContainer.of(context);
    final watchlist = container.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Желаемое'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildStatistics(themeState),
          const SizedBox(height: 20),
          Expanded(
            child: watchlist.isEmpty
                ? EmptyState(
              icon: Icons.list,
              title: 'Список пуст',
              subtitle: 'Добавьте фильмы, которые хотите посмотреть',
              themeState: themeState,
            )
                : ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: watchlist.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = watchlist[index];
                return WatchlistItemTile(
                  item: item,
                  onChanged: (_) {
                    container.toggleWatched(index);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddMovieForm,
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics(ThemeState themeState) {
    final watchlist = WatchlistContainer.of(context).watchlist;
    final total = watchlist.length;
    final watched = watchlist.where((item) => item.watched).length;
    final remaining = total - watched;

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
          _buildStatItem('Всего', total.toString(), Icons.movie, themeState),
          _buildStatItem('Просмотрено', watched.toString(), Icons.check_circle, themeState),
          _buildStatItem('Осталось', remaining.toString(), Icons.schedule, themeState),
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
            size: 24
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
}