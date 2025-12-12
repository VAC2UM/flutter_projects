import '../../core/usecases/usecase.dart';
import '../models/news_article.dart';
import '../interfaces/news_repository.dart';

class GetTopHeadlines
    implements UseCase<List<NewsArticle>, GetTopHeadlinesParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<List<NewsArticle>> call(GetTopHeadlinesParams params) async {
    return await repository.getTopHeadlines(
      country: params.country,
      category: params.category,
    );
  }
}

class GetTopHeadlinesParams {
  final String? country;
  final String? category;

  GetTopHeadlinesParams({this.country, this.category});
}
