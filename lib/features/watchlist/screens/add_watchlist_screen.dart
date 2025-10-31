import 'package:flutter/material.dart';

class AddWatchlistScreen extends StatefulWidget {
  const AddWatchlistScreen({super.key});

  @override
  State<AddWatchlistScreen> createState() => _AddWatchlistScreenState();
}

class _AddWatchlistScreenState extends State<AddWatchlistScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveMovie() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      Navigator.pop(context, {
        'title': title,
        'imageUrl': _imageUrlController.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите название фильма'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить в список'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Название фильма *',
                  prefixIcon: Icon(Icons.movie),
                  hintText: 'Введите название фильма',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL постера (опционально)',
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/poster.jpg',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Добавить в список'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}