import '../dto/watchlist_item_dto.dart';
import '../../../shared/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistItemDto>> getWatchlist();
  Future<WatchlistItemDto> addItem(WatchlistItemDto item);
  Future<void> deleteItem(String id);
  Future<WatchlistItemDto> toggleWatched(String id);
  Future<void> clearAllItems();
  Future<void> clearWatchedItems();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  @override
  Future<List<WatchlistItemDto>> getWatchlist() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableWatchlist,
    );

    return List.generate(maps.length, (i) {
      return WatchlistItemDto.fromMap(maps[i]);
    });
  }

  @override
  Future<WatchlistItemDto> addItem(WatchlistItemDto item) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      DatabaseHelper.tableWatchlist,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return item;
  }

  @override
  Future<void> deleteItem(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableWatchlist,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<WatchlistItemDto> toggleWatched(String id) async {
    final db = await DatabaseHelper.database;

    // Get current item
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableWatchlist,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('Item not found');
    }

    final currentItem = WatchlistItemDto.fromMap(maps.first);
    final updatedItem = WatchlistItemDto(
      id: currentItem.id,
      title: currentItem.title,
      watched: !currentItem.watched,
      imageUrl: currentItem.imageUrl,
    );

    await db.update(
      DatabaseHelper.tableWatchlist,
      updatedItem.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );

    return updatedItem;
  }

  @override
  Future<void> clearAllItems() async {
    final db = await DatabaseHelper.database;
    await db.delete(DatabaseHelper.tableWatchlist);
  }

  @override
  Future<void> clearWatchedItems() async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableWatchlist,
      where: '${DatabaseHelper.columnWatched} = ?',
      whereArgs: [1],
    );
  }
}
