import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _movieController = TextEditingController();
  List<String> _movies = [];

  void _addMovie() {
    setState(() {
      final input = _movieController.text.trim();
      if (input.isNotEmpty) {
        _movies.add(input);
      }
      _movieController.clear();
    });
  }

  void _removeMovie(int index) {
    setState(() {
      _movies.removeAt(index);
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Добавить фильм'),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _movies.isEmpty
                  ? Center(
                child: Text(
                  'Список фильмов пуст',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return GestureDetector(
                    onTap: () => _removeMovie(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple, width: 2),
                      ),
                      child: Text(
                        movie,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
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