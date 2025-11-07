import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/theme_state.dart';

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
      context.pop({
        'title': title,
        'imageUrl': _imageUrlController.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Введите название фильма'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить в список'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Название фильма *',
                  prefixIcon: Icon(
                      Icons.movie,
                      color: themeState.currentTheme.colorScheme.primary
                  ),
                  hintText: 'Введите название фильма',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'URL постера (опционально)',
                  prefixIcon: Icon(
                      Icons.image,
                      color: themeState.currentTheme.colorScheme.primary
                  ),
                  hintText: 'https://example.com/poster.jpg',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState.currentTheme.colorScheme.primary,
                  foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
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