// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbMovieDto _$TmdbMovieDtoFromJson(Map<String, dynamic> json) => TmdbMovieDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  overview: json['overview'] as String?,
  releaseDate: json['release_date'] as String?,
  voteAverage: (json['vote_average'] as num?)?.toDouble(),
  voteCount: (json['vote_count'] as num?)?.toInt(),
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$TmdbMovieDtoToJson(TmdbMovieDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'genres': instance.genres,
    };

TmdbMoviesResponseDto _$TmdbMoviesResponseDtoFromJson(
  Map<String, dynamic> json,
) => TmdbMoviesResponseDto(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => TmdbMovieDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPages: (json['total_pages'] as num).toInt(),
  totalResults: (json['total_results'] as num).toInt(),
);

Map<String, dynamic> _$TmdbMoviesResponseDtoToJson(
  TmdbMoviesResponseDto instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results,
  'total_pages': instance.totalPages,
  'total_results': instance.totalResults,
};
