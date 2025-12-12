import 'package:json_annotation/json_annotation.dart';
import 'tmdb_movie_dto.dart';

part 'tmdb_recommendations_dto.g.dart';

@JsonSerializable()
class TmdbRecommendationsResponseDto {
  final int page;
  final List<TmdbMovieDto> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  TmdbRecommendationsResponseDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbRecommendationsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbRecommendationsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbRecommendationsResponseDtoToJson(this);
}
