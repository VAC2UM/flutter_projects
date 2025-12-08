import '../dto/favorite_dto.dart';
import '../../../shared/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteDto>> getFavorites();
  Future<FavoriteDto> addFavorite(FavoriteDto favorite);
  Future<void> deleteFavorite(String id);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  @override
  Future<List<FavoriteDto>> getFavorites() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableFavorites,
    );

    return List.generate(maps.length, (i) {
      return FavoriteDto.fromMap(maps[i]);
    });
  }

  @override
  Future<FavoriteDto> addFavorite(FavoriteDto favorite) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      DatabaseHelper.tableFavorites,
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return favorite;
  }

  @override
  Future<void> deleteFavorite(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableFavorites,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }
}
