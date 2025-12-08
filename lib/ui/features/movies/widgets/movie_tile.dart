import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_projects/domain/models/movie.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MovieTile({super.key, required this.movie, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildMoviePoster(themeState),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeState.currentTheme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildRatingStars(),
                      const SizedBox(height: 4),
                      Text(
                        'Рейтинг: ${movie.rating}/10',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeState.currentTheme.colorScheme.onSurface
                              .withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (movie.director != null || movie.year != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${movie.director ?? ''} ${movie.year != null ? '(${movie.year})' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeState.currentTheme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeState.currentTheme.colorScheme.error
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: themeState.currentTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ThemeState themeState) {
    final defaultImageUrl =
        movie.imageUrl ??
        'https://via.placeholder.com/70x100/6c757d/ffffff?text=No+Image';

    return Container(
      width: 70,
      height: 100,
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
        child: CachedNetworkImage(
          imageUrl: defaultImageUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Container(
            color: themeState.currentTheme.colorScheme.surfaceVariant,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2,
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: themeState.currentTheme.colorScheme.surfaceVariant,
            child: Center(
              child: Icon(
                Icons.movie,
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    final starRating = (movie.rating / 2).round();
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < starRating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}
