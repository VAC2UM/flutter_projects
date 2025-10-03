import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _movieController = TextEditingController();
  String? _movieName;

  void _addMovie() {
    setState(() {
      final input = _movieController.text.trim();
      if (input.isEmpty) {
        _movieName = null;
      } else {
        _movieName = input;
      }
      _movieController.clear();
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
            if (_movieName != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: Text(
                  _movieName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
