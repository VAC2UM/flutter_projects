import '../../domain/models/review.dart';

class ReviewDto extends Review {
  ReviewDto({
    required super.id,
    required super.movieId,
    required super.movieTitle,
    required super.rating,
    required super.text,
    required super.createdAt,
    super.moviePosterUrl,
  });

  factory ReviewDto.fromEntity(Review review) {
    return ReviewDto(
      id: review.id,
      movieId: review.movieId,
      movieTitle: review.movieTitle,
      rating: review.rating,
      text: review.text,
      createdAt: review.createdAt,
      moviePosterUrl: review.moviePosterUrl,
    );
  }

  factory ReviewDto.fromMap(Map<String, dynamic> map) {
    return ReviewDto(
      id: map['id'] as String,
      movieId: map['movie_id'] as String,
      movieTitle: map['movieTitle'] as String,
      rating: map['rating'] as int,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      moviePosterUrl: map['moviePosterUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movie_id': movieId,
      'movieTitle': movieTitle,
      'rating': rating,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'moviePosterUrl': moviePosterUrl,
    };
  }

  Review toEntity() {
    return Review(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      rating: rating,
      text: text,
      createdAt: createdAt,
      moviePosterUrl: moviePosterUrl,
    );
  }
}
