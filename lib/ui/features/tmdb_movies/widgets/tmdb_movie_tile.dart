import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/models/tmdb_movie.dart';
import '../../../shared/theme_state.dart';

class TmdbMovieTile extends StatelessWidget {
  final TmdbMovie movie;
  final VoidCallback onTap;

  const TmdbMovieTile({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterPath!,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 150,
                        color:
                            themeState.currentTheme.colorScheme.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 150,
                        color:
                            themeState.currentTheme.colorScheme.surfaceVariant,
                        child: const Icon(Icons.movie),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 150,
                      color: themeState.currentTheme.colorScheme.surfaceVariant,
                      child: const Icon(Icons.movie),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeState.currentTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (movie.voteAverage != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.voteAverage!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  themeState.currentTheme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    if (movie.releaseDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        movie.releaseDate!.split('-')[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: themeState
                              .currentTheme
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (movie.overview != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        movie.overview!,
                        style: TextStyle(
                          fontSize: 12,
                          color: themeState
                              .currentTheme
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

