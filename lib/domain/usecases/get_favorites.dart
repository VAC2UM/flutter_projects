import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/favorite.dart';
import '../interfaces/favorites_repository.dart';

class GetFavorites implements UseCase<List<Favorite>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<List<Favorite>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
