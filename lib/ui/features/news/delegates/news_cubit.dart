import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_movies_news.dart';
import '../../../../domain/usecases/get_top_headlines.dart';
import '../../../../domain/usecases/search_news.dart';
import '../../../../domain/usecases/get_news_by_source.dart';
import '../../../../domain/usecases/get_news_by_date_range.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetMoviesNews getMoviesNews;
  final GetTopHeadlines getTopHeadlines;
  final SearchNews searchNews;
  final GetNewsBySource getNewsBySource;
  final GetNewsByDateRange getNewsByDateRange;

  NewsCubit({
    required this.getMoviesNews,
    required this.getTopHeadlines,
    required this.searchNews,
    required this.getNewsBySource,
    required this.getNewsByDateRange,
  }) : super(NewsInitial());

  Future<void> loadMoviesNews({int page = 1}) async {
    emit(NewsLoading());
    try {
      final articles = await getMoviesNews(GetMoviesNewsParams(page: page));
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }

  Future<void> loadTopHeadlines({String? country, String? category}) async {
    emit(NewsLoading());
    try {
      final articles = await getTopHeadlines(
        GetTopHeadlinesParams(country: country, category: category),
      );
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }

  Future<void> search(String query, {int page = 1}) async {
    emit(NewsLoading());
    try {
      final articles = await searchNews(
        SearchNewsParams(query: query, page: page),
      );
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }

  Future<void> loadBySource(String source, {int page = 1}) async {
    emit(NewsLoading());
    try {
      final articles = await getNewsBySource(
        GetNewsBySourceParams(source: source, page: page),
      );
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }

  Future<void> loadByDateRange(String from, String to, {int page = 1}) async {
    emit(NewsLoading());
    try {
      final articles = await getNewsByDateRange(
        GetNewsByDateRangeParams(from: from, to: to, page: page),
      );
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}

