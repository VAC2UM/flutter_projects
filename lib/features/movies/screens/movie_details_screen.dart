import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали фильма'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Вертикальная навигация назад
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Постер фильма
            _buildMoviePoster(),
            const SizedBox(height: 20),

            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildRatingStars(),
            const SizedBox(height: 20),

            _buildMovieInfo(),
            const SizedBox(height: 20),

            if (movie.description != null) _buildDescription(),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), // Вертикальная навигация назад
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
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

  Widget _buildMoviePoster() {
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
                  size: 50,
                ),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.director != null)
          _buildInfoRow('Режиссер', movie.director!),
        if (movie.year != null)
          _buildInfoRow('Год:', movie.year!.toString()),
        if (movie.genre != null)
          _buildInfoRow('Жанр:', movie.genre!),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Описание:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.description!,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}