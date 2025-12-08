import '../dto/movie_dto.dart';
import '../../../shared/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class MoviesLocalDataSource {
  Future<List<MovieDto>> getMovies();
  Future<MovieDto> getMovieById(String id);
  Future<MovieDto> addMovie(MovieDto movie);
  Future<void> deleteMovie(String id);
  Future<MovieDto> updateMovie(MovieDto movie);
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  @override
  Future<List<MovieDto>> getMovies() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableMovies,
    );

    return List.generate(maps.length, (i) {
      return MovieDto.fromMap(maps[i]);
    });
  }

  @override
  Future<MovieDto> getMovieById(String id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableMovies,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MovieDto.fromMap(maps.first);
    } else {
      throw Exception('Movie not found');
    }
  }

  @override
  Future<MovieDto> addMovie(MovieDto movie) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      DatabaseHelper.tableMovies,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return movie;
  }

  @override
  Future<void> deleteMovie(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableMovies,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<MovieDto> updateMovie(MovieDto movie) async {
    final db = await DatabaseHelper.database;
    final count = await db.update(
      DatabaseHelper.tableMovies,
      movie.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [movie.id],
    );

    if (count == 0) {
    throw Exception('Movie not found');
    }
    return movie;
  }
}
