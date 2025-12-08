import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_projects/domain/models/actor.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;
  final VoidCallback? onDelete;

  const ActorTile({super.key, required this.actor, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeState.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeState.currentTheme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActorPhoto(themeState),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actor.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeState.currentTheme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Актер',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeState.currentTheme.colorScheme.onSurface
                        .withOpacity(0.6),
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
                  color: themeState.currentTheme.colorScheme.error.withOpacity(
                    0.1,
                  ),
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
    );
  }

  Widget _buildActorPhoto(ThemeState themeState) {
    final defaultImageUrl =
        actor.imageUrl ??
        'https://donskoy.gosuslugi.ru/netcat_files/354/1988/net_foto_muzh.jpg';

    return Container(
      width: 80,
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
                Icons.person,
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
