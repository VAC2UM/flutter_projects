import '../models/movie.dart';
import '../models/tmdb_movie.dart';
import '../models/tmdb_actor.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getMovies();
  Future<Movie> getMovieById(String id);
  Future<Movie> addMovie(Movie movie);
  Future<void> deleteMovie(String id);
  Future<Movie> updateMovie(Movie movie);

  // TMDB methods
  Future<List<TmdbMovie>> getPopularMovies({int page = 1});
  Future<TmdbMovie> getTmdbMovieById(int movieId);
  Future<List<TmdbActor>> getMovieCredits(int movieId);
  Future<List<TmdbMovie>> searchMovies(String query, {int page = 1});
  Future<List<TmdbMovie>> getMovieRecommendations(int movieId, {int page = 1});
}
