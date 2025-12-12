import '../../core/usecases/usecase.dart';
import '../models/tmdb_movie.dart';
import '../interfaces/movies_repository.dart';

class SearchTmdbMovies
    implements UseCase<List<TmdbMovie>, SearchTmdbMoviesParams> {
  final MoviesRepository repository;

  SearchTmdbMovies(this.repository);

  @override
  Future<List<TmdbMovie>> call(SearchTmdbMoviesParams params) async {
    return await repository.searchMovies(params.query, page: params.page);
  }
}

class SearchTmdbMoviesParams {
  final String query;
  final int page;

  SearchTmdbMoviesParams({required this.query, this.page = 1});
}
