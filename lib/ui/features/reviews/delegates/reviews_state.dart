import 'package:flutter/foundation.dart';
import 'package:flutter_projects/domain/models/review.dart';

@immutable
class ReviewsState {
  final List<Review> reviews;
  final bool isLoading;
  final String? error;
  final bool isSubmitting;

  const ReviewsState({
    this.reviews = const [],
    this.isLoading = false,
    this.error,
    this.isSubmitting = false,
  });

  ReviewsState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    String? error,
    bool? isSubmitting,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewsState &&
        listEquals(other.reviews, reviews) &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isSubmitting == isSubmitting;
  }

  @override
  int get hashCode => Object.hash(reviews, isLoading, error, isSubmitting);
}
