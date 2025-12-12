abstract class TmdbMoviesEvent {}

class LoadPopularMovies extends TmdbMoviesEvent {
  final int page;

  LoadPopularMovies({this.page = 1});
}

class LoadTmdbMovieById extends TmdbMoviesEvent {
  final int movieId;

  LoadTmdbMovieById({required this.movieId});
}

class LoadMovieCredits extends TmdbMoviesEvent {
  final int movieId;

  LoadMovieCredits({required this.movieId});
}

class SearchMovies extends TmdbMoviesEvent {
  final String query;
  final int page;

  SearchMovies({required this.query, this.page = 1});
}

class LoadMovieRecommendations extends TmdbMoviesEvent {
  final int movieId;
  final int page;

  LoadMovieRecommendations({required this.movieId, this.page = 1});
}

