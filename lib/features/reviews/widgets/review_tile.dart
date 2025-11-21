import 'package:flutter/material.dart';
import '../models/review.dart';
import '../../../shared/theme/theme_state.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  final VoidCallback? onDelete;

  const ReviewTile({
    super.key,
    required this.review,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMoviePoster(themeState),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.movieTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeState.currentTheme.colorScheme.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: themeState.currentTheme.colorScheme.error.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete,
                          color: themeState.currentTheme.colorScheme.error,
                          size: 18,
                        ),
                      ),
                      onPressed: onDelete,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRatingStars(),
              const SizedBox(height: 12),
              Text(
                review.text,
                style: TextStyle(
                  fontSize: 14,
                  color: themeState.currentTheme.colorScheme.onSurface,
                  height: 1.4,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ThemeState themeState) {
    final defaultImageUrl = review.moviePosterUrl ??
        'https://via.placeholder.com/60x90/6c757d/ffffff?text=No+Image';

    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          defaultImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: themeState.currentTheme.colorScheme.surfaceVariant,
            child: Center(
              child: Icon(
                Icons.movie,
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: [
        Text(
          'Оценка: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          review.ratingStars,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          '(${review.rating}/5)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}