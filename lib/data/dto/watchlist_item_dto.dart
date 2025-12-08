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

  factory WatchlistItemDto.fromMap(Map<String, dynamic> map) {
    return WatchlistItemDto(
      id: map['id'] as String,
      title: map['title'] as String,
      watched: (map['watched'] as int) == 1,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'watched': watched ? 1 : 0,
      'imageUrl': imageUrl,
    };
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
