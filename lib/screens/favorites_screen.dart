import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _favorites = [];

  void _addFavorite() {
    final movie = _controller.text.trim();
    if (movie.isNotEmpty) {
      setState(() {
        _favorites.add(movie);
      });
      _controller.clear();
    }
  }

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите название фильма',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addFavorite, child: const Text('Добавить')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_favorites[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFavorite(index),
                      ),
                    ),
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
