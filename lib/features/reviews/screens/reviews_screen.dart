import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/reviews/models/review.dart';
import 'package:go_router/go_router.dart';
import '../cubit/reviews_cubit.dart';
import '../state/reviews_state.dart';
import '../widgets/review_tile.dart';
import '../../../shared/theme/theme_state.dart';
import '../../../shared/widgets/empty_state.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewsCubit(),
      child: const ReviewsView(),
    );
  }
}

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key});

  void _openAddReviewForm(BuildContext context) {
    final cubit = context.read<ReviewsCubit>();
    context.push('/reviews/add', extra: cubit);
  }

  void _deleteReviewWithUndo(BuildContext context, Review review) {
    final cubit = context.read<ReviewsCubit>();

    cubit.deleteReview(review.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён отзыв на фильм "${review.movieTitle}"'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            cubit.addReview(
              movieId: review.movieId,
              movieTitle: review.movieTitle,
              rating: review.rating,
              text: review.text,
              moviePosterUrl: review.moviePosterUrl,
            );
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои отзывы'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: themeState.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeState.currentTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReviewsCubit>().clearError();
                      context.read<ReviewsCubit>().loadReviews();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildStatistics(state, themeState),
              const SizedBox(height: 20),
              Expanded(
                child: state.reviews.isEmpty
                    ? EmptyState(
                  icon: Icons.reviews,
                  title: 'Нет отзывов',
                  subtitle: 'Добавьте свой первый отзыв на фильм',
                  themeState: themeState,
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: state.reviews.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return ReviewTile(
                      review: review,
                      onDelete: () => _deleteReviewWithUndo(context, review),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddReviewForm(context),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics(ReviewsState state, ThemeState themeState) {
    final totalReviews = state.reviews.length;
    final averageRating = totalReviews > 0
        ? state.reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews
        : 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeState.currentTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: themeState.currentTheme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Всего отзывов', totalReviews.toString(), Icons.reviews, themeState),
          _buildStatItem('Средняя оценка', averageRating.toStringAsFixed(1), Icons.star, themeState),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeState themeState) {
    return Column(
      children: [
        Icon(
          icon,
          color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}