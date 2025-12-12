import '../../domain/interfaces/news_repository.dart';
import '../../domain/models/news_article.dart';
import '../datasources/news_remote_data_source.dart';
import '../dto/news_article_dto.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsArticle>> getMoviesNews({int page = 1}) async {
    try {
      final response = await remoteDataSource.getMoviesNews(page: page);
      final articles = response.articles
          .map((dto) => _mapDtoToEntity(dto))
          .toList();
      // Сортируем по дате: свежие сверху
      articles.sort((a, b) {
        if (a.publishedAt == null && b.publishedAt == null) return 0;
        if (a.publishedAt == null) return 1;
        if (b.publishedAt == null) return -1;
        return b.publishedAt!.compareTo(a.publishedAt!);
      });
      return articles;
    } catch (e) {
      throw Exception('Failed to get movies news: $e');
    }
  }

  @override
  Future<List<NewsArticle>> getTopHeadlines({
    String? country,
    String? category,
  }) async {
    try {
      final response = await remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
      );
      final articles = response.articles
          .map((dto) => _mapDtoToEntity(dto))
          .toList();
      // Сортируем по дате: свежие сверху
      articles.sort((a, b) {
        if (a.publishedAt == null && b.publishedAt == null) return 0;
        if (a.publishedAt == null) return 1;
        if (b.publishedAt == null) return -1;
        return b.publishedAt!.compareTo(a.publishedAt!);
      });
      return articles;
    } catch (e) {
      throw Exception('Failed to get top headlines: $e');
    }
  }

  @override
  Future<List<NewsArticle>> searchNews(String query, {int page = 1}) async {
    try {
      final response = await remoteDataSource.searchNews(query, page: page);
      final articles = response.articles
          .map((dto) => _mapDtoToEntity(dto))
          .toList();
      // Сортируем по дате: свежие сверху
      articles.sort((a, b) {
        if (a.publishedAt == null && b.publishedAt == null) return 0;
        if (a.publishedAt == null) return 1;
        if (b.publishedAt == null) return -1;
        return b.publishedAt!.compareTo(a.publishedAt!);
      });
      return articles;
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }

  @override
  Future<List<NewsArticle>> getNewsBySource(
    String source, {
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.getNewsBySource(
        source,
        page: page,
      );
      return response.articles.map((dto) => _mapDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to get news by source: $e');
    }
  }

  @override
  Future<List<NewsArticle>> getNewsByDateRange(
    String from,
    String to, {
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.getNewsByDateRange(
        from,
        to,
        page: page,
      );
      return response.articles.map((dto) => _mapDtoToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Failed to get news by date range: $e');
    }
  }

  NewsArticle _mapDtoToEntity(NewsArticleDto dto) {
    return NewsArticle(
      title: dto.title,
      description: dto.description,
      url: dto.url,
      urlToImage: dto.urlToImage,
      publishedAt: dto.publishedAt,
      author: dto.author,
      sourceName: dto.source?.name,
      content: dto.content,
    );
  }
}

