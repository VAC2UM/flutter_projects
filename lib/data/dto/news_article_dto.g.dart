// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleDto _$NewsArticleDtoFromJson(Map<String, dynamic> json) =>
    NewsArticleDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      author: json['author'] as String?,
      source: json['source'] == null
          ? null
          : NewsSourceDto.fromJson(json['source'] as Map<String, dynamic>),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$NewsArticleDtoToJson(NewsArticleDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'publishedAt': instance.publishedAt,
      'author': instance.author,
      'source': instance.source,
      'content': instance.content,
    };

NewsSourceDto _$NewsSourceDtoFromJson(Map<String, dynamic> json) =>
    NewsSourceDto(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$NewsSourceDtoToJson(NewsSourceDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

NewsResponseDto _$NewsResponseDtoFromJson(Map<String, dynamic> json) =>
    NewsResponseDto(
      status: json['status'] as String,
      totalResults: (json['totalResults'] as num?)?.toInt(),
      articles: (json['articles'] as List<dynamic>)
          .map((e) => NewsArticleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsResponseDtoToJson(NewsResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResults': instance.totalResults,
      'articles': instance.articles,
    };
