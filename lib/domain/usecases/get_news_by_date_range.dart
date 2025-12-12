import '../../core/usecases/usecase.dart';
import '../models/news_article.dart';
import '../interfaces/news_repository.dart';

class GetNewsByDateRange
    implements UseCase<List<NewsArticle>, GetNewsByDateRangeParams> {
  final NewsRepository repository;

  GetNewsByDateRange(this.repository);

  @override
  Future<List<NewsArticle>> call(GetNewsByDateRangeParams params) async {
    return await repository.getNewsByDateRange(
      params.from,
      params.to,
      page: params.page,
    );
  }
}

class GetNewsByDateRangeParams {
  final String from;
  final String to;
  final int page;

  GetNewsByDateRangeParams({
    required this.from,
    required this.to,
    this.page = 1,
  });
}
