// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_recommendations_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbRecommendationsResponseDto _$TmdbRecommendationsResponseDtoFromJson(
  Map<String, dynamic> json,
) => TmdbRecommendationsResponseDto(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => TmdbMovieDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPages: (json['total_pages'] as num).toInt(),
  totalResults: (json['total_results'] as num).toInt(),
);

Map<String, dynamic> _$TmdbRecommendationsResponseDtoToJson(
  TmdbRecommendationsResponseDto instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results,
  'total_pages': instance.totalPages,
  'total_results': instance.totalResults,
};
