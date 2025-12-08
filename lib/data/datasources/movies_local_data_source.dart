import '../dto/movie_dto.dart';

abstract class MoviesLocalDataSource {
  Future<List<MovieDto>> getMovies();
  Future<MovieDto> getMovieById(String id);
  Future<MovieDto> addMovie(MovieDto movie);
  Future<void> deleteMovie(String id);
  Future<MovieDto> updateMovie(MovieDto movie);
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final List<MovieDto> _movies = [];

  MoviesLocalDataSourceImpl() {
    _movies.addAll([
      MovieDto(
        id: '1',
        title: 'Мстители: Финал',
        rating: 8,
        imageUrl:
            'https://a.ltrbxd.com/resized/film-poster/2/2/6/6/6/0/226660-avengers-endgame-0-2000-0-3000-crop.jpg?v=d4006bfd5e',
        director: 'Братья Руссо',
        year: 2019,
        genre: 'Фантастика',
      ),
      MovieDto(
        id: '2',
        title: 'Кентавр',
        rating: 7,
        imageUrl:
            'https://a.ltrbxd.com/resized/film-poster/1/0/2/9/9/1/0/1029910-centaur-2023-0-2000-0-3000-crop.jpg?v=fe28759575',
        director: 'Кирилл Кемниц',
        year: 2023,
        genre: 'Драма',
      ),
    ]);
  }

  @override
  Future<List<MovieDto>> getMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_movies);
  }

  @override
  Future<MovieDto> getMovieById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      throw Exception('Movie not found');
    }
  }

  @override
  Future<MovieDto> addMovie(MovieDto movie) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _movies.add(movie);
    return movie;
  }

  @override
  Future<void> deleteMovie(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _movies.removeWhere((movie) => movie.id == id);
  }

  @override
  Future<MovieDto> updateMovie(MovieDto movie) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
      return movie;
    }
    throw Exception('Movie not found');
  }
}
