import 'package:flutter_projects/core/usecases/usecase.dart';
import '../interfaces/favorites_repository.dart';

class DeleteFavorite implements UseCase<void, String> {
  final FavoritesRepository repository;

  DeleteFavorite(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteFavorite(id);
  }
}
