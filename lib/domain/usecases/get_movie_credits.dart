import '../../core/usecases/usecase.dart';
import '../models/tmdb_actor.dart';
import '../interfaces/movies_repository.dart';

class GetMovieCredits
    implements UseCase<List<TmdbActor>, GetMovieCreditsParams> {
  final MoviesRepository repository;

  GetMovieCredits(this.repository);

  @override
  Future<List<TmdbActor>> call(GetMovieCreditsParams params) async {
    return await repository.getMovieCredits(params.movieId);
  }
}

class GetMovieCreditsParams {
  final int movieId;

  GetMovieCreditsParams({required this.movieId});
}
