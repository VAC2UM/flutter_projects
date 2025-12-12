import '../../domain/models/movie.dart';
import '../../domain/models/tmdb_movie.dart';
import '../../domain/models/tmdb_actor.dart';
import '../../domain/interfaces/movies_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../datasources/tmdb_remote_data_source.dart';
import '../dto/movie_dto.dart';
import '../dto/tmdb_movie_dto.dart';
import '../dto/tmdb_actor_dto.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;
  final TmdbRemoteDataSource tmdbRemoteDataSource;

  MoviesRepositoryImpl(this.localDataSource, this.tmdbRemoteDataSource);

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

  // TMDB methods
  @override
  Future<List<TmdbMovie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await tmdbRemoteDataSource.getPopularMovies(page: page);
      return response.results.map((dto) => _mapTmdbDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to get popular movies: $e');
    }
  }

  @override
  Future<TmdbMovie> getTmdbMovieById(int movieId) async {
    try {
      final dto = await tmdbRemoteDataSource.getMovieById(movieId);
      return _mapTmdbDtoToEntity(dto);
    } catch (e) {
      throw Exception('Failed to get TMDB movie: $e');
    }
  }

  @override
  Future<List<TmdbActor>> getMovieCredits(int movieId) async {
    try {
      final credits = await tmdbRemoteDataSource.getMovieCredits(movieId);
      return credits.cast.map((dto) => _mapActorDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to get movie credits: $e');
    }
  }

  @override
  Future<List<TmdbMovie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await tmdbRemoteDataSource.searchMovies(
        query,
        page: page,
      );
      return response.results.map((dto) => _mapTmdbDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  @override
  Future<List<TmdbMovie>> getMovieRecommendations(
    int movieId, {
    int page = 1,
  }) async {
    try {
      final response = await tmdbRemoteDataSource.getMovieRecommendations(
        movieId,
        page: page,
      );
      return response.results.map((dto) => _mapTmdbDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to get movie recommendations: $e');
    }
  }

  TmdbMovie _mapTmdbDtoToEntity(TmdbMovieDto dto) {
    return TmdbMovie(
      id: dto.id,
      title: dto.title,
      posterPath: dto.fullPosterPath,
      backdropPath: dto.backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500${dto.backdropPath}'
          : null,
      overview: dto.overview,
      releaseDate: dto.releaseDate,
      voteAverage: dto.voteAverage,
      voteCount: dto.voteCount,
    );
  }

  TmdbActor _mapActorDtoToEntity(TmdbActorDto dto) {
    return TmdbActor(
      id: dto.id,
      name: dto.name,
      profilePath: dto.fullProfilePath,
      character: dto.character,
      knownForDepartment: dto.knownForDepartment,
    );
  }
}
