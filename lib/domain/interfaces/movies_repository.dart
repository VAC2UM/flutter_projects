import '../models/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getMovies();
  Future<Movie> getMovieById(String id);
  Future<Movie> addMovie(Movie movie);
  Future<void> deleteMovie(String id);
  Future<Movie> updateMovie(Movie movie);
}
