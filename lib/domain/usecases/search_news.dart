import '../../core/usecases/usecase.dart';
import '../models/news_article.dart';
import '../interfaces/news_repository.dart';

class SearchNews implements UseCase<List<NewsArticle>, SearchNewsParams> {
  final NewsRepository repository;

  SearchNews(this.repository);

  @override
  Future<List<NewsArticle>> call(SearchNewsParams params) async {
    return await repository.searchNews(params.query, page: params.page);
  }
}

class SearchNewsParams {
  final String query;
  final int page;

  SearchNewsParams({required this.query, this.page = 1});
}
