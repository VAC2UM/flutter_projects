import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../../../shared/theme/theme_state.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали фильма'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviePoster(themeState),
            const SizedBox(height: 20),

            Text(
              movie.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeState.currentTheme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),

            _buildRatingStars(themeState),
            const SizedBox(height: 20),

            _buildMovieInfo(themeState),
            const SizedBox(height: 20),

            if (movie.description != null) _buildDescription(themeState),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState.currentTheme.colorScheme.primary,
                  foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Вернуться к списку'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ThemeState themeState) {
    final imageUrl = movie.imageUrl ?? 'https://via.placeholder.com/300x400/6c757d/ffffff?text=No+Image';

    return Center(
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
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
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(ThemeState themeState) {
    final starRating = (movie.rating / 2).round();

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < starRating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 24,
            );
          }),
        ),
        const SizedBox(width: 10),
        Text(
          '${movie.rating}/10',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(ThemeState themeState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.director != null)
          _buildInfoRow('Режиссер', movie.director!, themeState),
        if (movie.year != null)
          _buildInfoRow('Год:', movie.year!.toString(), themeState),
        if (movie.genre != null)
          _buildInfoRow('Жанр:', movie.genre!, themeState),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeState themeState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: themeState.currentTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeState themeState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Описание:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.description!,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: themeState.currentTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}