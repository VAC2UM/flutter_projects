import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/domain/models/review.dart';
import '../delegates/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(const ReviewsState()) {
    loadReviews();
  }

  void loadReviews() {
    emit(state.copyWith(isLoading: true));

    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        final initialReviews = <Review>[
          Review(
            id: '1',
            movieId: '1',
            movieTitle: 'Мстители: Финал',
            rating: 5,
            text: 'Отличный фильм! Завершение саги просто великолепное. Особенно понравилась битва в третьем акте.',
            createdAt: DateTime(2024, 1, 15),
            moviePosterUrl: 'https://a.ltrbxd.com/resized/film-poster/2/2/6/6/6/0/226660-avengers-endgame-0-2000-0-3000-crop.jpg?v=d4006bfd5e',
          ),
          Review(
            id: '2',
            movieId: '2',
            movieTitle: 'Кентавр',
            rating: 4,
            text: 'Интересная драма с глубоким смыслом. Актёрская игра на высоте.',
            createdAt: DateTime(2024, 1, 10),
            moviePosterUrl: 'https://a.ltrbxd.com/resized/film-poster/1/0/2/9/9/1/0/1029910-centaur-2023-0-2000-0-3000-crop.jpg?v=fe28759575',
          ),
        ];

        emit(ReviewsState(
          reviews: initialReviews,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Ошибка загрузки отзывов: $e',
        ));
      }
    });
  }

  void addReview({
    required String movieId,
    required String movieTitle,
    required int rating,
    required String text,
    String? moviePosterUrl,
  }) {
    emit(state.copyWith(isSubmitting: true));

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final newReview = Review.create(
          movieId: movieId,
          movieTitle: movieTitle,
          rating: rating,
          text: text,
          moviePosterUrl: moviePosterUrl,
        );

        final updatedReviews = List<Review>.from(state.reviews)..add(newReview);

        emit(state.copyWith(
          reviews: updatedReviews,
          isSubmitting: false,
          error: null,
        ));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          error: 'Ошибка добавления отзыва: $e',
        ));
      }
    });
  }

  void deleteReview(String id) {
    try {
      final updatedReviews = List<Review>.from(state.reviews)
        ..removeWhere((review) => review.id == id);

      emit(state.copyWith(
        reviews: updatedReviews,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка удаления отзыва: $e'));
    }
  }

  void updateReview(String id, {int? rating, String? text}) {
    try {
      final updatedReviews = state.reviews.map((review) {
        if (review.id == id) {
          return Review(
            id: review.id,
            movieId: review.movieId,
            movieTitle: review.movieTitle,
            rating: rating ?? review.rating,
            text: text ?? review.text,
            createdAt: review.createdAt,
            moviePosterUrl: review.moviePosterUrl,
          );
        }
        return review;
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