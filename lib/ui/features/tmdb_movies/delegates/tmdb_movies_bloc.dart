import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_popular_movies.dart';
import '../../../../domain/usecases/get_tmdb_movie_by_id.dart';
import '../../../../domain/usecases/get_movie_credits.dart';
import '../../../../domain/usecases/search_tmdb_movies.dart';
import '../../../../domain/usecases/get_movie_recommendations.dart';
import 'tmdb_movies_event.dart';
import 'tmdb_movies_state.dart';

class TmdbMoviesBloc extends Bloc<TmdbMoviesEvent, TmdbMoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetTmdbMovieById getTmdbMovieById;
  final GetMovieCredits getMovieCredits;
  final SearchTmdbMovies searchTmdbMovies;
  final GetMovieRecommendations getMovieRecommendations;

  TmdbMoviesBloc({
    required this.getPopularMovies,
    required this.getTmdbMovieById,
    required this.getMovieCredits,
    required this.searchTmdbMovies,
    required this.getMovieRecommendations,
  }) : super(TmdbMoviesInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadTmdbMovieById>(_onLoadTmdbMovieById);
    on<LoadMovieCredits>(_onLoadMovieCredits);
    on<SearchMovies>(_onSearchMovies);
    on<LoadMovieRecommendations>(_onLoadMovieRecommendations);
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<TmdbMoviesState> emit,
  ) async {
    emit(TmdbMoviesLoading());
    try {
      final movies = await getPopularMovies(
        GetPopularMoviesParams(page: event.page),
      );
      emit(TmdbMoviesLoaded(movies: movies));
    } catch (e) {
      emit(TmdbMoviesError(message: e.toString()));
    }
  }

  Future<void> _onLoadTmdbMovieById(
    LoadTmdbMovieById event,
    Emitter<TmdbMoviesState> emit,
  ) async {
    emit(TmdbMoviesLoading());
    try {
      final movie = await getTmdbMovieById(
        GetTmdbMovieByIdParams(movieId: event.movieId),
      );
      emit(TmdbMovieLoaded(movie: movie));
    } catch (e) {
      emit(TmdbMoviesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMovieCredits(
    LoadMovieCredits event,
    Emitter<TmdbMoviesState> emit,
  ) async {
    emit(TmdbMoviesLoading());
    try {
      final actors = await getMovieCredits(
        GetMovieCreditsParams(movieId: event.movieId),
      );
      emit(TmdbMovieCreditsLoaded(actors: actors));
    } catch (e) {
      emit(TmdbMoviesError(message: e.toString()));
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<TmdbMoviesState> emit,
  ) async {
    emit(TmdbMoviesLoading());
    try {
      final movies = await searchTmdbMovies(
        SearchTmdbMoviesParams(query: event.query, page: event.page),
      );
      emit(TmdbMoviesLoaded(movies: movies));
    } catch (e) {
      emit(TmdbMoviesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMovieRecommendations(
    LoadMovieRecommendations event,
    Emitter<TmdbMoviesState> emit,
  ) async {
    emit(TmdbMoviesLoading());
    try {
      final movies = await getMovieRecommendations(
        GetMovieRecommendationsParams(movieId: event.movieId, page: event.page),
      );
      emit(TmdbMoviesLoaded(movies: movies));
    } catch (e) {
      emit(TmdbMoviesError(message: e.toString()));
    }
  }
}

