import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_projects/domain/models/favorite.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class FavoriteTile extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback? onDelete;

  const FavoriteTile({super.key, required this.favorite, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    Row(
                      children: [
                        Icon(
                            Icons.favorite,
                            color: themeState.currentTheme.colorScheme.error,
                            size: 18
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            favorite.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeState.currentTheme.colorScheme.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: themeState.currentTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Избранное',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeState.currentTheme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeState.currentTheme.colorScheme.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        Icons.delete,
                        color: themeState.currentTheme.colorScheme.error,
                        size: 20
                    ),
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ThemeState themeState) {
    final defaultImageUrl = favorite.imageUrl ?? 'https://avatars.mds.yandex.net/i?id=2834d31489c7357b9f67b9489064ecafb1fd8a03-12601053-images-thumbs&n=13';

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
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: defaultImageUrl,
              fit: BoxFit.cover,
              width: 70,
              height: 100,
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
                child: const Center(
                  child: Icon(
                    Icons.movie,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
