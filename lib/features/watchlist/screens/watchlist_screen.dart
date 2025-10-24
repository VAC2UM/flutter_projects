import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/watchlist_container.dart';
import '../widgets/watchlist_item_tile.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addMovie() {
    final title = _titleController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (title.isNotEmpty) {
      WatchlistContainer.of(context).addMovie(
        title: title,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      _titleController.clear();
      _imageUrlController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Желаемое'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildAddMovieForm(),
            const SizedBox(height: 20),
            _buildStatistics(),
            const SizedBox(height: 20),
            Expanded(
              child: StatefulBuilder(
                builder: (context, setState) {
                  final watchlist = WatchlistContainer.of(context).watchlist;

                  if (watchlist.isEmpty) {
                    return const EmptyState(
                      icon: Icons.list,
                      title: 'Список пуст',
                      subtitle: 'Добавьте фильмы, которые хотите посмотреть',
                    );
                  }

                  return ListView.separated(
                    itemCount: watchlist.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = watchlist[index];
                      return WatchlistItemTile(
                        item: item,
                        onChanged: (_) {
                          WatchlistContainer.of(context).toggleWatched(index);
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

  Widget _buildAddMovieForm() {
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
          onPressed: _addMovie,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Добавить в список'),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return StatefulBuilder(
      builder: (context, setState) {
        final watchlist = WatchlistContainer.of(context).watchlist;
        final total = watchlist.length;
        final watched = watchlist.where((item) => item.watched).length;
        final remaining = total - watched;

        return Container(
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
      },
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