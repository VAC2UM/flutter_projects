import 'package:flutter_projects/domain/models/movie.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  MoviesLoaded(this.movies);
}

class MovieLoaded extends MoviesState {
  final Movie movie;
  MovieLoaded(this.movie);
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}

class MovieOperationSuccess extends MoviesState {
  final String message;
  MovieOperationSuccess(this.message);
}
