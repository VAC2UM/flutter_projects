import '../../domain/models/movie.dart';
import '../../domain/interfaces/movies_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../dto/movie_dto.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;

  MoviesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Movie>> getMovies() async {
    try {
      final movies = await localDataSource.getMovies();
      return movies.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get movies: $e');
    }
  }

  @override
  Future<Movie> getMovieById(String id) async {
    try {
      final movie = await localDataSource.getMovieById(id);
      return movie.toEntity();
    } catch (e) {
      throw Exception('Failed to get movie: $e');
    }
  }

  @override
  Future<Movie> addMovie(Movie movie) async {
    try {
      final movieModel = MovieDto.fromEntity(movie);
      final addedMovie = await localDataSource.addMovie(movieModel);
      return addedMovie.toEntity();
    } catch (e) {
      throw Exception('Failed to add movie: $e');
    }
  }

  @override
  Future<void> deleteMovie(String id) async {
    try {
      await localDataSource.deleteMovie(id);
    } catch (e) {
      throw Exception('Failed to delete movie: $e');
    }
  }

  @override
  Future<Movie> updateMovie(Movie movie) async {
    try {
      final movieModel = MovieDto.fromEntity(movie);
      final updatedMovie = await localDataSource.updateMovie(movieModel);
      return updatedMovie.toEntity();
    } catch (e) {
      throw Exception('Failed to update movie: $e');
    }
  }
}
