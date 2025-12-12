import 'package:json_annotation/json_annotation.dart';

part 'tmdb_movie_dto.g.dart';

@JsonSerializable()
class TmdbMovieDto {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final String? overview;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  final List<Map<String, dynamic>>? genres;

  TmdbMovieDto({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genres,
  });

  factory TmdbMovieDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbMovieDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbMovieDtoToJson(this);

  String? get fullPosterPath =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;
}

@JsonSerializable()
class TmdbMoviesResponseDto {
  final int page;
  final List<TmdbMovieDto> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  TmdbMoviesResponseDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbMoviesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbMoviesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbMoviesResponseDtoToJson(this);
}

