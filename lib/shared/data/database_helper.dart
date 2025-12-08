import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'movies_app.db';
  static const int _databaseVersion = 3;

  // Table names
  static const String tableMovies = 'movies';
  static const String tableFavorites = 'favorites';
  static const String tableWatchlist = 'watchlist';
  static const String tableReviews = 'reviews';

  // Movies table columns
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnRating = 'rating';
  static const String columnImageUrl = 'imageUrl';
  static const String columnDescription = 'description';
  static const String columnYear = 'year';
  static const String columnGenre = 'genre';
  static const String columnDirector = 'director';

  // Favorites table columns (inherits id, title, imageUrl from movies)
  // Uses movie_id as foreign key

  // Watchlist table columns
  static const String columnWatched = 'watched';
  static const String columnMovieId = 'movie_id';

  // Reviews table columns
  static const String columnMovieTitle = 'movieTitle';
  static const String columnText = 'text';
  static const String columnCreatedAt = 'createdAt';
  static const String columnMoviePosterUrl = 'moviePosterUrl';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Enable foreign keys
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create movies table
    await db.execute('''
      CREATE TABLE $tableMovies (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnRating INTEGER NOT NULL,
        $columnImageUrl TEXT,
        $columnDescription TEXT,
        $columnYear INTEGER,
        $columnGenre TEXT,
        $columnDirector TEXT
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE $tableFavorites (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnImageUrl TEXT,
        $columnMovieId TEXT,
        FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
      )
    ''');

    // Create watchlist table
    await db.execute('''
      CREATE TABLE $tableWatchlist (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnImageUrl TEXT,
        $columnWatched INTEGER NOT NULL DEFAULT 0,
        $columnMovieId TEXT,
        FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
      )
    ''');

    // Create reviews table
    await db.execute('''
      CREATE TABLE $tableReviews (
        $columnId TEXT PRIMARY KEY,
        $columnMovieId TEXT NOT NULL,
        $columnMovieTitle TEXT NOT NULL,
        $columnRating INTEGER NOT NULL,
        $columnText TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnMoviePosterUrl TEXT,
        FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
      )
    ''');

    // Insert initial movies
    await _insertInitialMovies(db);

    // Insert initial reviews
    await _insertInitialReviews(db);
  }

  static Future<void> _insertInitialMovies(Database db) async {
    await db.insert(tableMovies, {
      columnId: '1',
      columnTitle: 'Мстители: Финал',
      columnRating: 8,
      columnImageUrl:
          'https://a.ltrbxd.com/resized/film-poster/2/2/6/6/6/0/226660-avengers-endgame-0-2000-0-3000-crop.jpg?v=d4006bfd5e',
      columnDirector: 'Братья Руссо',
      columnYear: 2019,
      columnGenre: 'Фантастика',
    });

    await db.insert(tableMovies, {
      columnId: '2',
      columnTitle: 'Кентавр',
      columnRating: 7,
      columnImageUrl:
          'https://a.ltrbxd.com/resized/film-poster/1/0/2/9/9/1/0/1029910-centaur-2023-0-2000-0-3000-crop.jpg?v=fe28759575',
      columnDirector: 'Кирилл Кемниц',
      columnYear: 2023,
      columnGenre: 'Драма',
    });
  }

  static Future<void> _insertInitialReviews(Database db) async {
    await db.insert(tableReviews, {
      columnId: '1',
      columnMovieId: '1',
      columnMovieTitle: 'Мстители: Финал',
      columnRating: 5,
      columnText:
          'Отличный фильм! Завершение саги просто великолепное. Особенно понравилась битва в третьем акте.',
      columnCreatedAt: DateTime(2024, 1, 15).toIso8601String(),
      columnMoviePosterUrl:
          'https://a.ltrbxd.com/resized/film-poster/2/2/6/6/6/0/226660-avengers-endgame-0-2000-0-3000-crop.jpg?v=d4006bfd5e',
    });

    await db.insert(tableReviews, {
      columnId: '2',
      columnMovieId: '2',
      columnMovieTitle: 'Кентавр',
      columnRating: 4,
      columnText:
          'Интересная драма с глубоким смыслом. Актёрская игра на высоте.',
      columnCreatedAt: DateTime(2024, 1, 10).toIso8601String(),
      columnMoviePosterUrl:
          'https://a.ltrbxd.com/resized/film-poster/1/0/2/9/9/1/0/1029910-centaur-2023-0-2000-0-3000-crop.jpg?v=fe28759575',
    });
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Add reviews table for version 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableReviews (
          $columnId TEXT PRIMARY KEY,
          $columnMovieId TEXT NOT NULL,
          $columnMovieTitle TEXT NOT NULL,
          $columnRating INTEGER NOT NULL,
          $columnText TEXT NOT NULL,
          $columnCreatedAt TEXT NOT NULL,
          $columnMoviePosterUrl TEXT,
          FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 3) {
      // Fix column name if it was created incorrectly
      // Check if table exists and has wrong column name
      try {
        final result = await db.rawQuery("PRAGMA table_info($tableReviews)");
        final hasWrongColumn = result.any((row) => row['name'] == 'movield');
        if (hasWrongColumn) {
          // Drop and recreate table with correct schema
          await db.execute('DROP TABLE IF EXISTS $tableReviews');
          await db.execute('''
            CREATE TABLE $tableReviews (
              $columnId TEXT PRIMARY KEY,
              $columnMovieId TEXT NOT NULL,
              $columnMovieTitle TEXT NOT NULL,
              $columnRating INTEGER NOT NULL,
              $columnText TEXT NOT NULL,
              $columnCreatedAt TEXT NOT NULL,
              $columnMoviePosterUrl TEXT,
              FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
            )
          ''');
        }
      } catch (e) {
        // If table doesn't exist, create it
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableReviews (
            $columnId TEXT PRIMARY KEY,
            $columnMovieId TEXT NOT NULL,
            $columnMovieTitle TEXT NOT NULL,
            $columnRating INTEGER NOT NULL,
            $columnText TEXT NOT NULL,
            $columnCreatedAt TEXT NOT NULL,
            $columnMoviePosterUrl TEXT,
            FOREIGN KEY ($columnMovieId) REFERENCES $tableMovies($columnId) ON DELETE CASCADE
          )
        ''');
      }
    }
  }

  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
