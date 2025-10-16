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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addMovie() {
    final movie = _controller.text.trim();
    if (movie.isNotEmpty) {
      WatchlistContainer.of(context).addMovie(movie);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Желаемое')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите фильм',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Добавить в список'),
            ),
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

                  return ListView.builder(
                    itemCount: watchlist.length,
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
}
