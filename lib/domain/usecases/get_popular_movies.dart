import '../../core/usecases/usecase.dart';
import '../models/tmdb_movie.dart';
import '../interfaces/movies_repository.dart';

class GetPopularMovies
    implements UseCase<List<TmdbMovie>, GetPopularMoviesParams> {
  final MoviesRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<List<TmdbMovie>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams {
  final int page;

  GetPopularMoviesParams({this.page = 1});
}

