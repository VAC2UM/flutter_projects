import '../../core/usecases/usecase.dart';
import '../models/news_article.dart';
import '../interfaces/news_repository.dart';

class GetMoviesNews implements UseCase<List<NewsArticle>, GetMoviesNewsParams> {
  final NewsRepository repository;

  GetMoviesNews(this.repository);

  @override
  Future<List<NewsArticle>> call(GetMoviesNewsParams params) async {
    return await repository.getMoviesNews(page: params.page);
  }
}

class GetMoviesNewsParams {
  final int page;

  GetMoviesNewsParams({this.page = 1});
}
