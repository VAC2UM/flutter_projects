class Movie {
  final String id;
  final String title;
  final int rating;

  Movie({required this.id, required this.title, required this.rating});

  Movie.create({required this.title, required this.rating})
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  String toString() {
    return '$title (Рейтинг: $rating/10)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.rating == rating;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ rating.hashCode;
}
