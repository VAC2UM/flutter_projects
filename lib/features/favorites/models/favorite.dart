class Favorite {
  final String id;
  final String title;

  Favorite({required this.id, required this.title});

  Favorite.create({required this.title})
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
