class Favorite {
  final String id;
  final String title;
  final String? imageUrl;

  const Favorite({
    required this.id,
    required this.title,
    this.imageUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite &&
        other.id == id &&
        other.title == title &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ imageUrl.hashCode;
}
