import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/watchlist_container.dart';
import '../widgets/watchlist_item_tile.dart';
import 'add_watchlist_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  void _openAddMovieForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWatchlistScreen(),
      ),
    );

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
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = WatchlistContainer.of(context);
    final watchlist = container.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Желаемое'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildStatistics(),
          const SizedBox(height: 20),
          Expanded(
            child: watchlist.isEmpty
                ? const EmptyState(
              icon: Icons.list,
              title: 'Список пуст',
              subtitle: 'Добавьте фильмы, которые хотите посмотреть',
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
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics() {
    final watchlist = WatchlistContainer.of(context).watchlist;
    final total = watchlist.length;
    final watched = watchlist.where((item) => item.watched).length;
    final remaining = total - watched;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Всего', total.toString(), Icons.movie),
          _buildStatItem('Просмотрено', watched.toString(), Icons.check_circle),
          _buildStatItem('Осталось', remaining.toString(), Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[700], size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green[600],
          ),
        ),
      ],
    );
  }
}