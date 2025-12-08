import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/movie.dart';
import '../interfaces/movies_repository.dart';

class AddMovie implements UseCase<Movie, Movie> {
  final MoviesRepository repository;

  AddMovie(this.repository);

  @override
  Future<Movie> call(Movie movie) async {
    return await repository.addMovie(movie);
  }
}
