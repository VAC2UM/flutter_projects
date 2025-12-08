class Review {
  final String id;
  final String movieId;
  final String movieTitle;
  final int rating;
  final String text;
  final DateTime createdAt;
  final String? moviePosterUrl;

  Review({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.rating,
    required this.text,
    required this.createdAt,
    this.moviePosterUrl,
  });

  Review.create({
    required this.movieId,
    required this.movieTitle,
    required this.rating,
    required this.text,
    this.moviePosterUrl,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = DateTime.now();

  String get formattedDate {
    return '${createdAt.day}.${createdAt.month}.${createdAt.year}';
  }

  String get ratingStars {
    return '⭐' * rating;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review &&
        other.id == id &&
        other.movieId == movieId;
  }

  @override
  int get hashCode => id.hashCode ^ movieId.hashCode;
}