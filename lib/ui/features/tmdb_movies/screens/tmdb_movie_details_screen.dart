import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/models/tmdb_movie.dart';
import '../delegates/tmdb_movies_bloc.dart';
import '../delegates/tmdb_movies_event.dart';
import '../delegates/tmdb_movies_state.dart';
import '../widgets/actor_tile.dart';
import '../widgets/tmdb_movie_tile.dart';
import '../../../shared/theme_state.dart';

class TmdbMovieDetailsScreen extends StatelessWidget {
  final TmdbMovie movie;

  const TmdbMovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);
    final bloc = context.read<TmdbMoviesBloc>();

    // Загружаем актеров и рекомендации при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(LoadMovieCredits(movieId: movie.id));
      bloc.add(LoadMovieRecommendations(movieId: movie.id));
    });

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
            if (movie.voteAverage != null) _buildRating(themeState),
            const SizedBox(height: 20),
            if (movie.overview != null) _buildDescription(themeState),
            const SizedBox(height: 30),
            _buildActorsSection(context, bloc, themeState),
            const SizedBox(height: 30),
            _buildRecommendationsSection(context, bloc, themeState),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ThemeState themeState) {
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
          child: movie.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: movie.posterPath!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: themeState.currentTheme.colorScheme.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: themeState.currentTheme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.movie, size: 50),
                  ),
                )
              : Container(
                  color: themeState.currentTheme.colorScheme.surfaceVariant,
                  child: const Icon(Icons.movie, size: 50),
                ),
        ),
      ),
    );
  }

  Widget _buildRating(ThemeState themeState) {
    final rating = movie.voteAverage!;
    final starRating = (rating / 2).round();

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
          '${rating.toStringAsFixed(1)}/10',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
        if (movie.voteCount != null) ...[
          const SizedBox(width: 10),
          Text(
            '(${movie.voteCount} оценок)',
            style: TextStyle(
              fontSize: 14,
              color: themeState.currentTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
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
          movie.overview!,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: themeState.currentTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.justify,
        ),
        if (movie.releaseDate != null) ...[
          const SizedBox(height: 12),
          Text(
            'Дата выхода: ${movie.releaseDate!.split('-')[0]}',
            style: TextStyle(
              fontSize: 14,
              color: themeState.currentTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActorsSection(
    BuildContext context,
    TmdbMoviesBloc bloc,
    ThemeState themeState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Актеры:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<TmdbMoviesBloc, TmdbMoviesState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is TmdbMovieCreditsLoaded) {
              if (state.actors.isEmpty) {
                return Text(
                  'Информация об актерах недоступна',
                  style: TextStyle(
                    color: themeState.currentTheme.colorScheme.onSurfaceVariant,
                  ),
                );
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.actors.length,
                  itemBuilder: (context, index) {
                    return ActorTile(actor: state.actors[index]);
                  },
                ),
              );
            }

            if (state is TmdbMoviesLoading) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
    BuildContext context,
    TmdbMoviesBloc bloc,
    ThemeState themeState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Рекомендации:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<TmdbMoviesBloc, TmdbMoviesState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is TmdbMoviesLoaded && state.movies.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final recommendedMovie = state.movies[index];
                  return TmdbMovieTile(
                    movie: recommendedMovie,
                    onTap: () {
                      context.push(
                        '/tmdb-movies/details',
                        extra: recommendedMovie,
                      );
                    },
                  );
                },
              );
            }

            if (state is TmdbMoviesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Text(
              'Рекомендации не найдены',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ],
    );
  }
}

