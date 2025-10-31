import 'package:flutter/material.dart';
import '../widgets/rating_slider.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _movieController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  int _currentRating = 5;

  @override
  void dispose() {
    _movieController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
  }

  void _saveMovie() {
    final title = _movieController.text.trim();
    if (title.isNotEmpty) {
      Navigator.pop(context, {
        'title': title,
        'rating': _currentRating,
        'imageUrl': _imageUrlController.text.trim(),
        'description': _descriptionController.text.trim(),
        'director': _directorController.text.trim(),
        'year': _yearController.text.trim(),
        'genre': _genreController.text.trim(),
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
        title: const Text('Добавить фильм'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _movieController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Название фильма *',
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
              const SizedBox(height: 12),
              TextField(
                controller: _directorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Режиссер (опционально)',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Год (опционально)',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _genreController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Жанр (опционально)',
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Описание (опционально)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              RatingSlider(
                value: _currentRating,
                onChanged: _updateRating,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Сохранить фильм'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}