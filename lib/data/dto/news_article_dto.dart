import 'package:json_annotation/json_annotation.dart';

part 'news_article_dto.g.dart';

@JsonSerializable()
class NewsArticleDto {
  final String? title;
  final String? description;
  final String? url;
  @JsonKey(name: 'urlToImage')
  final String? urlToImage;
  @JsonKey(name: 'publishedAt')
  final String? publishedAt;
  final String? author;
  final NewsSourceDto? source;
  final String? content;

  NewsArticleDto({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.source,
    this.content,
  });

  factory NewsArticleDto.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleDtoToJson(this);
}

@JsonSerializable()
class NewsSourceDto {
  final String? id;
  final String? name;

  NewsSourceDto({this.id, this.name});

  factory NewsSourceDto.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsSourceDtoToJson(this);
}

@JsonSerializable()
class NewsResponseDto {
  final String status;
  @JsonKey(name: 'totalResults')
  final int? totalResults;
  final List<NewsArticleDto> articles;

  NewsResponseDto({
    required this.status,
    this.totalResults,
    required this.articles,
  });

  factory NewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseDtoToJson(this);
}

