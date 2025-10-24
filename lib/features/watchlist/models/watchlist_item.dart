class WatchlistItem {
  final String id;
  final String title;
  final bool watched;
  final String? imageUrl;

  WatchlistItem({
    required this.id,
    required this.title,
    required this.watched,
    this.imageUrl,
  });

  WatchlistItem.create({
    required this.title,
    required this.watched,
    this.imageUrl,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  WatchlistItem copyWith({
    String? id,
    String? title,
    bool? watched,
    String? imageUrl,
  }) {
    return WatchlistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      watched: watched ?? this.watched,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WatchlistItem &&
        other.id == id &&
        other.title == title &&
        other.watched == watched &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ watched.hashCode ^ imageUrl.hashCode;
}