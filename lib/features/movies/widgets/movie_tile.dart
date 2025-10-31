import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MovieTile({super.key, required this.movie, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildMoviePoster(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (movie.director != null || movie.year != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${movie.director ?? ''} ${movie.year != null ? '(${movie.year})' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.red, size: 20),
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

  Widget _buildMoviePoster() {
    final defaultImageUrl = movie.imageUrl ?? 'https://via.placeholder.com/70x100/6c757d/ffffff?text=No+Image';

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
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.movie,
                color: Colors.grey,
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