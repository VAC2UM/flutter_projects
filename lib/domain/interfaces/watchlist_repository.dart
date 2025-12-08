import '../models/watchlist_item.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistItem>> getWatchlist();
  Future<WatchlistItem> addItem(WatchlistItem item);
  Future<void> deleteItem(String id);
  Future<WatchlistItem> toggleWatched(String id);
  Future<void> clearAllItems();
  Future<void> clearWatchedItems();
}
