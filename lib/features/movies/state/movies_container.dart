import 'package:flutter/material.dart';
import '../models/movie.dart';

class MoviesContainer extends StatefulWidget {
  final Widget child;

  const MoviesContainer({super.key, required this.child});

  @override
  State<MoviesContainer> createState() => _MoviesContainerState();

  static _MoviesContainerState of(BuildContext context) {
    return context.findAncestorStateOfType<_MoviesContainerState>()!;
  }
}

class _MoviesContainerState extends State<MoviesContainer> {
  final List<Movie> _movies = [];
  int _selectedRating = 5;

  List<Movie> get movies => List.unmodifiable(_movies);
  int get selectedRating => _selectedRating;

  void addMovie({required String title, required int rating, String? imageUrl}) {
    setState(() {
      _movies.add(Movie.create(title: title, rating: rating, imageUrl: imageUrl));
    });
  }

  void deleteMovie(BuildContext context, Movie movie, VoidCallback onUpdated) {
    final index = _movies.indexOf(movie);
    if (index == -1) return;

    final removedMovie = _movies[index];

    setState(() {
      _movies.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён фильм: ${removedMovie.title}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            _restoreMovie(removedMovie, index);
            onUpdated();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    onUpdated();
  }

  void _restoreMovie(Movie movie, int index) {
    setState(() {
      _movies.insert(index, movie);
    });
  }

  void setRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}