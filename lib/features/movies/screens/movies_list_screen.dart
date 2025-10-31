import 'package:flutter/material.dart';
import 'package:flutter_projects/features/movies/models/movie.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/empty_state.dart';
import '../state/movies_container.dart';
import '../widgets/movie_tile.dart';
import 'add_movie_screen.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  void _openAddMovieForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMovieScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      _addMovieFromForm(result);
    }
  }

  void _addMovieFromForm(Map<String, dynamic> movieData) {
    final container = MoviesContainer.of(context);

    container.addMovie(
      title: movieData['title'],
      rating: movieData['rating'],
      imageUrl: movieData['imageUrl'].isEmpty ? null : movieData['imageUrl'],
      description: movieData['description'].isEmpty ? null : movieData['description'],
      director: movieData['director'].isEmpty ? null : movieData['director'],
      year: movieData['year'].isEmpty ? null : int.tryParse(movieData['year']),
      genre: movieData['genre'].isEmpty ? null : movieData['genre'],
    );

    setState(() {});
  }

  void _navigateToMovieDetails(Movie movie) {
    context.push('/movies/details', extra: movie);
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
      body: movies.isEmpty
          ? const EmptyState(
        icon: Icons.movie,
        title: 'Нет фильмов',
        subtitle: 'Добавьте свой первый фильм с рейтингом',
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieTile(
            movie: movie,
            onTap: () => _navigateToMovieDetails(movie),
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
      // Кнопка + для вертикальной навигации
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddMovieForm,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}