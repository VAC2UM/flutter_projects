import '../dto/watchlist_item_dto.dart';

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistItemDto>> getWatchlist();
  Future<WatchlistItemDto> addItem(WatchlistItemDto item);
  Future<void> deleteItem(String id);
  Future<WatchlistItemDto> toggleWatched(String id);
  Future<void> clearAllItems();
  Future<void> clearWatchedItems();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final List<WatchlistItemDto> _items = [];

  @override
  Future<List<WatchlistItemDto>> getWatchlist() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<WatchlistItemDto> addItem(WatchlistItemDto item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
    return item;
  }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<WatchlistItemDto> toggleWatched(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      final updatedItem = WatchlistItemDto(
        id: item.id,
        title: item.title,
        watched: !item.watched,
        imageUrl: item.imageUrl,
      );
      _items[index] = updatedItem;
      return updatedItem;
    }
    throw Exception('Item not found');
  }

  @override
  Future<void> clearAllItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.clear();
  }

  @override
  Future<void> clearWatchedItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.watched);
  }
}
