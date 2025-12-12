import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../../../domain/models/news_article.dart';
import '../../../shared/theme_state.dart';

class NewsArticleTile extends StatelessWidget {
  final NewsArticle article;

  const NewsArticleTile({super.key, required this.article});

  Future<void> _openUrl(String? url) async {
    if (url != null) {
      final uri = Uri.parse(url);
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _openUrl(article.url),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: themeState.currentTheme.colorScheme.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: themeState.currentTheme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.article),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeState.currentTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (article.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeState
                            .currentTheme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (article.sourceName != null)
                        Expanded(
                          child: Text(
                            article.sourceName!,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  themeState.currentTheme.colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (article.publishedAt != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(article.publishedAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: themeState
                                .currentTheme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

