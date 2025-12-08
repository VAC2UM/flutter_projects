import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/movies_bloc.dart';
import '../delegates/movies_event.dart';
import '../delegates/movies_state.dart';
import '../widgets/movie_tile.dart';
import 'package:flutter_projects/ui/shared/empty_state.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: themeState.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeState.currentTheme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MoviesBloc>().add(LoadMovies());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is MoviesLoaded) {
            if (state.movies.isEmpty) {
              return EmptyState(
                icon: Icons.movie,
                title: 'Нет фильмов',
                subtitle: 'Список фильмов пуст',
                themeState: themeState,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: state.movies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieTile(
                  movie: movie,
                  onTap: () => context.push('/movies/details', extra: movie),
                  onDelete: () => _showDeleteDialog(context, movie.id),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/movies/add'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String movieId) {
    final themeState = ThemeState.of(context);
    final moviesBloc = context.read<MoviesBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить фильм?'),
        content: const Text(
          'Вы уверены, что хотите удалить этот фильм? Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              moviesBloc.add(DeleteMovieEvent(movieId));
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: themeState.currentTheme.colorScheme.error,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
