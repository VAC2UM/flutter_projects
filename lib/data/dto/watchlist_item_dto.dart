import '../../domain/models/watchlist_item.dart';

class WatchlistItemDto extends WatchlistItem {
  WatchlistItemDto({
    required super.id,
    required super.title,
    required super.watched,
    super.imageUrl,
  });

  factory WatchlistItemDto.fromEntity(WatchlistItem item) {
    return WatchlistItemDto(
      id: item.id,
      title: item.title,
      watched: item.watched,
      imageUrl: item.imageUrl,
    );
  }

  WatchlistItem toEntity() {
    return WatchlistItem(
      id: id,
      title: title,
      watched: watched,
      imageUrl: imageUrl,
    );
  }
}
