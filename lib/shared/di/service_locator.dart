import 'package:get_it/get_it.dart';
import '../../data/datasources/movies_local_data_source.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../domain/interfaces/movies_repository.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/get_movie_by_id.dart';
import '../../domain/usecases/add_movie.dart';
import '../../domain/usecases/delete_movie.dart';
import '../../ui/features/movies/delegates/movies_bloc.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/interfaces/favorites_repository.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/delete_favorite.dart';
import '../../ui/features/favorites/delegates/favorites_bloc.dart';
import '../../data/datasources/watchlist_local_data_source.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/interfaces/watchlist_repository.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/add_watchlist_item.dart';
import '../../domain/usecases/delete_watchlist_item.dart';
import '../../domain/usecases/toggle_watched.dart';
import '../../ui/features/watchlist/delegates/watchlist_bloc.dart';
import '../../data/datasources/reviews_local_data_source.dart';
import '../../ui/features/reviews/delegates/reviews_cubit.dart';
import '../data/data_source.dart';
import '../data/preferences_helper.dart';
import '../data/database_helper.dart';
import '../../data/datasources/tmdb_remote_data_source.dart';
import '../../data/datasources/news_remote_data_source.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/interfaces/news_repository.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_tmdb_movie_by_id.dart';
import '../../domain/usecases/get_movie_credits.dart';
import '../../domain/usecases/search_tmdb_movies.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import '../../domain/usecases/get_movies_news.dart';
import '../../domain/usecases/get_top_headlines.dart';
import '../../domain/usecases/search_news.dart';
import '../../domain/usecases/get_news_by_source.dart';
import '../../domain/usecases/get_news_by_date_range.dart';
import '../../ui/features/tmdb_movies/delegates/tmdb_movies_bloc.dart';
import '../../ui/features/news/delegates/news_cubit.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  String currentUser = '';

  void setCurrentUser(String user) {
    currentUser = user;
  }

  void logout() {
    currentUser = '';
  }

  bool get isAuthenticated => currentUser.isNotEmpty;
}

Future<void> setupLocator() async {
  // Initialize storage
  await PreferencesHelper.init(); // SharedPreferences для темы
  await DatabaseHelper.database; // SQLite для структурированных данных
  // Flutter Secure Storage не требует явной инициализации,
  // он инициализируется автоматически при первом использовании

  // Data Sources
  locator.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<ReviewsLocalDataSource>(
    () => ReviewsLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<TmdbRemoteDataSource>(
    () => TmdbRemoteDataSourceImpl(),
  );
  locator.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(),
  );

  // Repositories
  locator.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      locator<MoviesLocalDataSource>(),
      locator<TmdbRemoteDataSource>(),
    ),
  );
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(locator<NewsRemoteDataSource>()),
  );
  locator.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(locator<FavoritesLocalDataSource>()),
  );
  locator.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(locator<WatchlistLocalDataSource>()),
  );

  // Use Cases - Movies
  locator.registerLazySingleton(() => GetMovies(locator<MoviesRepository>()));
  locator.registerLazySingleton(
    () => GetMovieById(locator<MoviesRepository>()),
  );
  locator.registerLazySingleton(() => AddMovie(locator<MoviesRepository>()));
  locator.registerLazySingleton(() => DeleteMovie(locator<MoviesRepository>()));

  // Use Cases - Favorites
  locator.registerLazySingleton(
    () => GetFavorites(locator<FavoritesRepository>()),
  );
  locator.registerLazySingleton(
    () => AddFavorite(locator<FavoritesRepository>()),
  );
  locator.registerLazySingleton(
    () => DeleteFavorite(locator<FavoritesRepository>()),
  );

  // Use Cases - Watchlist
  locator.registerLazySingleton(
    () => GetWatchlist(locator<WatchlistRepository>()),
  );
  locator.registerLazySingleton(
    () => AddWatchlistItem(locator<WatchlistRepository>()),
  );
  locator.registerLazySingleton(
    () => DeleteWatchlistItem(locator<WatchlistRepository>()),
  );
  locator.registerLazySingleton(
    () => ToggleWatched(locator<WatchlistRepository>()),
  );

  // Use Cases - TMDB Movies
  locator.registerLazySingleton(
    () => GetPopularMovies(locator<MoviesRepository>()),
  );
  locator.registerLazySingleton(
    () => GetTmdbMovieById(locator<MoviesRepository>()),
  );
  locator.registerLazySingleton(
    () => GetMovieCredits(locator<MoviesRepository>()),
  );
  locator.registerLazySingleton(
    () => SearchTmdbMovies(locator<MoviesRepository>()),
  );
  locator.registerLazySingleton(
    () => GetMovieRecommendations(locator<MoviesRepository>()),
  );

  // Use Cases - News
  locator.registerLazySingleton(() => GetMoviesNews(locator<NewsRepository>()));
  locator.registerLazySingleton(
    () => GetTopHeadlines(locator<NewsRepository>()),
  );
  locator.registerLazySingleton(() => SearchNews(locator<NewsRepository>()));
  locator.registerLazySingleton(
    () => GetNewsBySource(locator<NewsRepository>()),
  );
  locator.registerLazySingleton(
    () => GetNewsByDateRange(locator<NewsRepository>()),
  );

  // BLoCs - используем lazySingleton для сохранения состояния между экранами
  locator.registerLazySingleton(
    () => MoviesBloc(
      getMovies: locator<GetMovies>(),
      getMovieById: locator<GetMovieById>(),
      addMovie: locator<AddMovie>(),
      deleteMovie: locator<DeleteMovie>(),
    ),
  );
  locator.registerLazySingleton(
    () => FavoritesBloc(
      getFavorites: locator<GetFavorites>(),
      addFavorite: locator<AddFavorite>(),
      deleteFavorite: locator<DeleteFavorite>(),
    ),
  );
  locator.registerLazySingleton(
    () => WatchlistBloc(
      getWatchlist: locator<GetWatchlist>(),
      addWatchlistItem: locator<AddWatchlistItem>(),
      deleteWatchlistItem: locator<DeleteWatchlistItem>(),
      toggleWatched: locator<ToggleWatched>(),
      repository: locator<WatchlistRepository>(),
    ),
  );
  locator.registerLazySingleton(() => ReviewsCubit());
  locator.registerLazySingleton(
    () => TmdbMoviesBloc(
      getPopularMovies: locator<GetPopularMovies>(),
      getTmdbMovieById: locator<GetTmdbMovieById>(),
      getMovieCredits: locator<GetMovieCredits>(),
      searchTmdbMovies: locator<SearchTmdbMovies>(),
      getMovieRecommendations: locator<GetMovieRecommendations>(),
    ),
  );
  locator.registerLazySingleton(
    () => NewsCubit(
      getMoviesNews: locator<GetMoviesNews>(),
      getTopHeadlines: locator<GetTopHeadlines>(),
      searchNews: locator<SearchNews>(),
      getNewsBySource: locator<GetNewsBySource>(),
      getNewsByDateRange: locator<GetNewsByDateRange>(),
    ),
  );

  // App State Service
  locator.registerSingleton<AppStateService>(AppStateService());

  // AppData (для актеров, режиссеров, студий)
  locator.registerSingleton<AppData>(AppData.initial());
}
