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

  void addMovie(String title, int rating) {
    setState(() {
      _movies.add(Movie.create(title: title, rating: rating));
    });
  }

  void removeMovie(Movie movie) {
    setState(() {
      _movies.remove(movie);
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
