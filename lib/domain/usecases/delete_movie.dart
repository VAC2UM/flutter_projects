import 'package:flutter_projects/core/usecases/usecase.dart';
import '../interfaces/movies_repository.dart';

class DeleteMovie implements UseCase<void, String> {
  final MoviesRepository repository;

  DeleteMovie(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteMovie(id);
  }
}
