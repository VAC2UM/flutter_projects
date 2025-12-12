import '../../core/usecases/usecase.dart';
import '../models/news_article.dart';
import '../interfaces/news_repository.dart';

class GetNewsBySource
    implements UseCase<List<NewsArticle>, GetNewsBySourceParams> {
  final NewsRepository repository;

  GetNewsBySource(this.repository);

  @override
  Future<List<NewsArticle>> call(GetNewsBySourceParams params) async {
    return await repository.getNewsBySource(params.source, page: params.page);
  }
}

class GetNewsBySourceParams {
  final String source;
  final int page;

  GetNewsBySourceParams({required this.source, this.page = 1});
}
