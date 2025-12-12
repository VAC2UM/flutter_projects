import '../../core/usecases/usecase.dart';
import '../models/tmdb_movie.dart';
import '../interfaces/movies_repository.dart';

class GetMovieRecommendations
    implements UseCase<List<TmdbMovie>, GetMovieRecommendationsParams> {
  final MoviesRepository repository;

  GetMovieRecommendations(this.repository);

  @override
  Future<List<TmdbMovie>> call(GetMovieRecommendationsParams params) async {
    return await repository.getMovieRecommendations(
      params.movieId,
      page: params.page,
    );
  }
}

class GetMovieRecommendationsParams {
  final int movieId;
  final int page;

  GetMovieRecommendationsParams({required this.movieId, this.page = 1});
}
