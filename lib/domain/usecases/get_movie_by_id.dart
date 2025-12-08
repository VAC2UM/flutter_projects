import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/movie.dart';
import '../interfaces/movies_repository.dart';

class GetMovieById implements UseCase<Movie, String> {
  final MoviesRepository repository;

  GetMovieById(this.repository);

  @override
  Future<Movie> call(String id) async {
    return await repository.getMovieById(id);
  }
}
