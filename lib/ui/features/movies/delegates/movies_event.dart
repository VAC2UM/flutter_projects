import 'package:flutter_projects/domain/models/movie.dart';

abstract class MoviesEvent {}

class LoadMovies extends MoviesEvent {}

class AddMovieEvent extends MoviesEvent {
  final Movie movie;
  AddMovieEvent(this.movie);
}

class DeleteMovieEvent extends MoviesEvent {
  final String id;
  DeleteMovieEvent(this.id);
}

class GetMovieByIdEvent extends MoviesEvent {
  final String id;
  GetMovieByIdEvent(this.id);
}
