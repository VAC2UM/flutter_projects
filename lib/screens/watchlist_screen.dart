import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _watchlist = [];

  void _addMovie() {
    final movie = _controller.text.trim();
    if (movie.isNotEmpty) {
      setState(() {
        _watchlist.add({'title': movie, 'watched': false});
      });
      _controller.clear();
    }
  }

  void _toggleWatched(int index) {
    setState(() {
      _watchlist[index]['watched'] = !_watchlist[index]['watched'];
    });
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
            ElevatedButton(onPressed: _addMovie, child: const Text('Добавить в список')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _watchlist.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_watchlist[index]['title']),
                    value: _watchlist[index]['watched'],
                    onChanged: (_) => _toggleWatched(index),
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
