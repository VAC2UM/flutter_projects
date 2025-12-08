import '../dto/review_dto.dart';
import '../../../shared/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class ReviewsLocalDataSource {
  Future<List<ReviewDto>> getReviews();
  Future<List<ReviewDto>> getReviewsByMovieId(String movieId);
  Future<ReviewDto> addReview(ReviewDto review);
  Future<void> deleteReview(String id);
  Future<ReviewDto> updateReview(ReviewDto review);
}

class ReviewsLocalDataSourceImpl implements ReviewsLocalDataSource {
  @override
  Future<List<ReviewDto>> getReviews() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableReviews,
      orderBy: '${DatabaseHelper.columnCreatedAt} DESC',
    );

    return List.generate(maps.length, (i) {
      return ReviewDto.fromMap(maps[i]);
    });
  }

  @override
  Future<List<ReviewDto>> getReviewsByMovieId(String movieId) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableReviews,
      where: '${DatabaseHelper.columnMovieId} = ?',
      whereArgs: [movieId],
      orderBy: '${DatabaseHelper.columnCreatedAt} DESC',
    );

    return List.generate(maps.length, (i) {
      return ReviewDto.fromMap(maps[i]);
    });
  }

  @override
  Future<ReviewDto> addReview(ReviewDto review) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      DatabaseHelper.tableReviews,
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return review;
  }

  @override
  Future<void> deleteReview(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableReviews,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<ReviewDto> updateReview(ReviewDto review) async {
    final db = await DatabaseHelper.database;
    final count = await db.update(
      DatabaseHelper.tableReviews,
      review.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [review.id],
    );

    if (count == 0) {
      throw Exception('Review not found');
    }
    return review;
  }
}
