import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/favorite.dart';
import '../interfaces/favorites_repository.dart';

class AddFavorite implements UseCase<Favorite, Favorite> {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  @override
  Future<Favorite> call(Favorite favorite) async {
    return await repository.addFavorite(favorite);
  }
}
