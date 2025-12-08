import '../dto/favorite_dto.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteDto>> getFavorites();
  Future<FavoriteDto> addFavorite(FavoriteDto favorite);
  Future<void> deleteFavorite(String id);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final List<FavoriteDto> _favorites = [];

  @override
  Future<List<FavoriteDto>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_favorites);
  }

  @override
  Future<FavoriteDto> addFavorite(FavoriteDto favorite) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _favorites.add(favorite);
    return favorite;
  }

  @override
  Future<void> deleteFavorite(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _favorites.removeWhere((fav) => fav.id == id);
  }
}
