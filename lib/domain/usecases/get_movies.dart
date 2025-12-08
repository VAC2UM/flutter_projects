import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/movie.dart';
import '../interfaces/movies_repository.dart';

class GetMovies implements UseCase<List<Movie>, NoParams> {
  final MoviesRepository repository;

  GetMovies(this.repository);

  @override
  Future<List<Movie>> call(NoParams params) async {
    return await repository.getMovies();
  }
}
