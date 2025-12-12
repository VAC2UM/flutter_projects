import '../../../../domain/models/tmdb_movie.dart';
import '../../../../domain/models/tmdb_actor.dart';

abstract class TmdbMoviesState {}

class TmdbMoviesInitial extends TmdbMoviesState {}

class TmdbMoviesLoading extends TmdbMoviesState {}

class TmdbMoviesLoaded extends TmdbMoviesState {
  final List<TmdbMovie> movies;

  TmdbMoviesLoaded({required this.movies});
}

class TmdbMovieLoaded extends TmdbMoviesState {
  final TmdbMovie movie;

  TmdbMovieLoaded({required this.movie});
}

class TmdbMovieCreditsLoaded extends TmdbMoviesState {
  final List<TmdbActor> actors;

  TmdbMovieCreditsLoaded({required this.actors});
}

class TmdbMoviesError extends TmdbMoviesState {
  final String message;

  TmdbMoviesError({required this.message});
}

