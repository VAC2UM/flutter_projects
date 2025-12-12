import '../models/news_article.dart';

abstract class NewsRepository {
  Future<List<NewsArticle>> getMoviesNews({int page = 1});
  Future<List<NewsArticle>> getTopHeadlines({
    String? country,
    String? category,
  });
  Future<List<NewsArticle>> searchNews(String query, {int page = 1});
  Future<List<NewsArticle>> getNewsBySource(String source, {int page = 1});
  Future<List<NewsArticle>> getNewsByDateRange(
    String from,
    String to, {
    int page = 1,
  });
}

