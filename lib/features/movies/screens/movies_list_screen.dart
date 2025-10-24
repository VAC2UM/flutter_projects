import 'package:flutter/material.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/movies_container.dart';
import '../widgets/movie_tile.dart';
import '../widgets/rating_slider.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final TextEditingController _movieController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  int _currentRating = 5;

  @override
  void dispose() {
    _movieController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addMovie() {
    final title = _movieController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (title.isNotEmpty) {
      final container = MoviesContainer.of(context);
      container.addMovie(
        title: title,
        rating: _currentRating,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      _movieController.clear();
      _imageUrlController.clear();
      setState(() {
        _currentRating = 5;
      });
    }
  }

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final container = MoviesContainer.of(context);
    final movies = container.movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildAddMovieForm(),
            const SizedBox(height: 20),
            Expanded(
              child: movies.isEmpty
                  ? const EmptyState(
                icon: Icons.movie,
                title: 'Нет фильмов',
                subtitle: 'Добавьте свой первый фильм с рейтингом',
              )
                  : ListView.separated(
                itemCount: movies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieTile(
                    movie: movie,
                    onDelete: () {
                      container.deleteMovie(
                        context,
                        movie,
                            () => setState(() {}),
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
          controller: _movieController,
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
        const SizedBox(height: 20),
        RatingSlider(
          value: _currentRating,
          onChanged: _updateRating,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addMovie,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Добавить фильм'),
        ),
      ],
    );
  }
}