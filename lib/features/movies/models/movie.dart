class Movie {
  final String id;
  final String title;
  final int rating;
  final String? imageUrl;
  final String? description;
  final int? year;
  final String? genre;
  final String? director;

  Movie({
    required this.id,
    required this.title,
    required this.rating,
    this.imageUrl,
    this.description,
    this.year,
    this.genre,
    this.director,
  });

  Movie.create({
    required this.title,
    required this.rating,
    this.imageUrl,
    this.description,
    this.year,
    this.genre,
    this.director,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

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
        other.rating == rating &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ rating.hashCode ^ imageUrl.hashCode;
}