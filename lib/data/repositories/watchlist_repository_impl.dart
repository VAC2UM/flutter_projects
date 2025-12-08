import '../../domain/models/watchlist_item.dart';
import '../../domain/interfaces/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';
import '../dto/watchlist_item_dto.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl(this.localDataSource);

  @override
  Future<List<WatchlistItem>> getWatchlist() async {
    try {
      final items = await localDataSource.getWatchlist();
      return items.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get watchlist: $e');
    }
  }

  @override
  Future<WatchlistItem> addItem(WatchlistItem item) async {
    try {
      final itemModel = WatchlistItemDto.fromEntity(item);
      final addedItem = await localDataSource.addItem(itemModel);
      return addedItem.toEntity();
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await localDataSource.deleteItem(id);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Future<WatchlistItem> toggleWatched(String id) async {
    try {
      final item = await localDataSource.toggleWatched(id);
      return item.toEntity();
    } catch (e) {
      throw Exception('Failed to toggle watched: $e');
    }
  }

  @override
  Future<void> clearAllItems() async {
    try {
      await localDataSource.clearAllItems();
    } catch (e) {
      throw Exception('Failed to clear all items: $e');
    }
  }

  @override
  Future<void> clearWatchedItems() async {
    try {
      await localDataSource.clearWatchedItems();
    } catch (e) {
      throw Exception('Failed to clear watched items: $e');
    }
  }
}
