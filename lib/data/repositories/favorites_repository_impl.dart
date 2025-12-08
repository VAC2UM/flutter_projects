import '../../domain/models/favorite.dart';
import '../../domain/interfaces/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../dto/favorite_dto.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Favorite>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return favorites.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<Favorite> addFavorite(Favorite favorite) async {
    try {
      final favoriteModel = FavoriteDto.fromEntity(favorite);
      final addedFavorite = await localDataSource.addFavorite(favoriteModel);
      return addedFavorite.toEntity();
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      await localDataSource.deleteFavorite(id);
    } catch (e) {
      throw Exception('Failed to delete favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String title) async {
    try {
      final favorites = await localDataSource.getFavorites();
      return favorites.any((fav) => fav.title == title);
    } catch (e) {
      return false;
    }
  }
}
