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

  @override
  void dispose() {
    _movieController.dispose();
    super.dispose();
  }

  void _addMovie() {
    final title = _movieController.text.trim();
    if (title.isNotEmpty) {
      final container = MoviesContainer.of(context);
      container.addMovie(title, container.selectedRating);
      _movieController.clear();
      container.setRating(5);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = MoviesContainer.of(context);
    final movies = container.movies;

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
            StatefulBuilder(
              builder: (context, setState) {
                return RatingSlider(
                  value: container.selectedRating,
                  onChanged: (rating) {
                    container.setRating(rating);
                    setState(() {});
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Добавить фильм'),
            ),
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
                separatorBuilder: (_, __) =>
                const Divider(color: Colors.grey, height: 1),
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
}
