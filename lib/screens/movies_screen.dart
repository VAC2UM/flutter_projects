import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _movieController = TextEditingController();
  final List<String> _movies = [];

  void _addMovie() {
    setState(() {
      final input = _movieController.text.trim();
      if (input.isNotEmpty) {
        _movies.add(input);
      }
      _movieController.clear();
    });
  }

  void _removeMovie(String movie) {
    setState(() {
      _movies.remove(movie);
    });
  }

  @override
  void dispose() {
    _movieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фильмы')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _movieController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите название фильма',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Добавить фильм'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _movies.map((movie) {
                  return Card(
                    key: ValueKey(movie),
                    child: ListTile(
                      leading: const Icon(
                        Icons.movie,
                        color: Colors.deepPurple,
                      ),
                      title: Text(movie, style: const TextStyle(fontSize: 16)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeMovie(movie),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}