import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/models/tmdb_actor.dart';
import '../../../shared/theme_state.dart';

class ActorTile extends StatelessWidget {
  final TmdbActor actor;

  const ActorTile({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: actor.profilePath != null
                ? CachedNetworkImage(
                    imageUrl: actor.profilePath!,
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 140,
                      color: themeState.currentTheme.colorScheme.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 140,
                      color: themeState.currentTheme.colorScheme.surfaceVariant,
                      child: const Icon(Icons.person),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 140,
                    color: themeState.currentTheme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.person),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            actor.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: themeState.currentTheme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (actor.character != null) ...[
            const SizedBox(height: 2),
            Text(
              actor.character!,
              style: TextStyle(
                fontSize: 9,
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
