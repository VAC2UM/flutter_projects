import '../../core/usecases/usecase.dart';
import '../models/tmdb_movie.dart';
import '../interfaces/movies_repository.dart';

class GetTmdbMovieById implements UseCase<TmdbMovie, GetTmdbMovieByIdParams> {
  final MoviesRepository repository;

  GetTmdbMovieById(this.repository);

  @override
  Future<TmdbMovie> call(GetTmdbMovieByIdParams params) async {
    return await repository.getTmdbMovieById(params.movieId);
  }
}

class GetTmdbMovieByIdParams {
  final int movieId;

  GetTmdbMovieByIdParams({required this.movieId});
}
