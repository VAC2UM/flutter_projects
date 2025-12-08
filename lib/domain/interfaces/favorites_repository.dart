import '../models/favorite.dart';

abstract class FavoritesRepository {
  Future<List<Favorite>> getFavorites();
  Future<Favorite> addFavorite(Favorite favorite);
  Future<void> deleteFavorite(String id);
  Future<bool> isFavorite(String title);
}
