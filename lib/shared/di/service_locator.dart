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
  await PreferencesHelper.init();
  await DatabaseHelper.database; // Initialize database

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

  // Repositories
  locator.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(locator<MoviesLocalDataSource>()),
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

  // App State Service
  locator.registerSingleton<AppStateService>(AppStateService());

  // AppData (для актеров, режиссеров, студий)
  locator.registerSingleton<AppData>(AppData.initial());
}
