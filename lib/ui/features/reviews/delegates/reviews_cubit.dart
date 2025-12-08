import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/domain/models/review.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:flutter_projects/data/datasources/reviews_local_data_source.dart';
import 'package:flutter_projects/data/dto/review_dto.dart';
import '../delegates/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsLocalDataSource _dataSource;

  ReviewsCubit()
    : _dataSource = locator<ReviewsLocalDataSource>(),
      super(const ReviewsState()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    emit(state.copyWith(isLoading: true));

    try {
      final reviewDtos = await _dataSource.getReviews();
      final reviews = reviewDtos.map((dto) => dto.toEntity()).toList();

      emit(ReviewsState(reviews: reviews, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Ошибка загрузки отзывов: $e'),
      );
    }
  }

  Future<void> addReview({
    required String movieId,
    required String movieTitle,
    required int rating,
    required String text,
    String? moviePosterUrl,
  }) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      final newReview = Review.create(
        movieId: movieId,
        movieTitle: movieTitle,
        rating: rating,
        text: text,
        moviePosterUrl: moviePosterUrl,
      );

      final reviewDto = ReviewDto.fromEntity(newReview);
      await _dataSource.addReview(reviewDto);

      final updatedReviews = List<Review>.from(state.reviews)..add(newReview);

      emit(
        state.copyWith(
          reviews: updatedReviews,
          isSubmitting: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'Ошибка добавления отзыва: $e',
        ),
      );
    }
  }

  Future<void> deleteReview(String id) async {
    try {
      await _dataSource.deleteReview(id);

      final updatedReviews = List<Review>.from(state.reviews)
        ..removeWhere((review) => review.id == id);

      emit(state.copyWith(reviews: updatedReviews, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка удаления отзыва: $e'));
    }
  }

  Future<void> updateReview(String id, {int? rating, String? text}) async {
    try {
      final review = state.reviews.firstWhere((r) => r.id == id);
      final updatedReview = Review(
        id: review.id,
        movieId: review.movieId,
        movieTitle: review.movieTitle,
        rating: rating ?? review.rating,
        text: text ?? review.text,
        createdAt: review.createdAt,
        moviePosterUrl: review.moviePosterUrl,
      );

      final reviewDto = ReviewDto.fromEntity(updatedReview);
      await _dataSource.updateReview(reviewDto);

      final updatedReviews = state.reviews.map((r) {
        return r.id == id ? updatedReview : r;
      }).toList();

      emit(state.copyWith(reviews: updatedReviews));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка обновления отзыва: $e'));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  List<Review> getReviewsForMovie(String movieId) {
    return state.reviews.where((review) => review.movieId == movieId).toList();
  }
}
