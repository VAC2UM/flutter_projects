import 'package:flutter/material.dart';
import 'package:flutter_projects/features/movies/models/movie.dart';
import 'package:flutter_projects/features/movies/widgets/movie_tile.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'movie_details_screen.dart';

class MoviesListScreen extends StatefulWidget {
  final List<Movie> movies;

  const MoviesListScreen({super.key, required this.movies});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  void _navigateToMovieDetails(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: widget.movies.isEmpty
          ? const EmptyState(
        icon: Icons.movie,
        title: 'Нет фильмов',
        subtitle: 'Список фильмов пуст',
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: widget.movies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return MovieTile(
            movie: movie,
            onTap: () => _navigateToMovieDetails(movie),
          );
        },
      ),
    );
  }
}