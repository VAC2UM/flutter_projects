import '../../domain/models/movie.dart';

class MovieDto extends Movie {
  MovieDto({
    required super.id,
    required super.title,
    required super.rating,
    super.imageUrl,
    super.description,
    super.year,
    super.genre,
    super.director,
  });

  factory MovieDto.fromEntity(Movie movie) {
    return MovieDto(
      id: movie.id,
      title: movie.title,
      rating: movie.rating,
      imageUrl: movie.imageUrl,
      description: movie.description,
      year: movie.year,
      genre: movie.genre,
      director: movie.director,
    );
  }

  factory MovieDto.fromJson(Map<String, dynamic> json) {
    return MovieDto(
      id: json['id'] as String,
      title: json['title'] as String,
      rating: json['rating'] as int,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      year: json['year'] as int?,
      genre: json['genre'] as String?,
      director: json['director'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'year': year,
      'genre': genre,
      'director': director,
    };
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      rating: rating,
      imageUrl: imageUrl,
      description: description,
      year: year,
      genre: genre,
      director: director,
    );
  }
}
