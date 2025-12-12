import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/tmdb_movies_bloc.dart';
import '../delegates/tmdb_movies_event.dart';
import '../delegates/tmdb_movies_state.dart';
import '../widgets/tmdb_movie_tile.dart';
import '../../../shared/empty_state.dart';
import '../../../shared/theme_state.dart';

class PopularMoviesScreen extends StatelessWidget {
  const PopularMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);
    final bloc = context.read<TmdbMoviesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Популярные фильмы'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TmdbMoviesBloc, TmdbMoviesState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is TmdbMoviesInitial) {
            bloc.add(LoadPopularMovies());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TmdbMoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TmdbMoviesError) {
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
                      bloc.add(LoadPopularMovies());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is TmdbMoviesLoaded) {
            if (state.movies.isEmpty) {
              return EmptyState(
                icon: Icons.movie,
                title: 'Нет фильмов',
                subtitle: 'Популярные фильмы не найдены',
                themeState: themeState,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                bloc.add(LoadPopularMovies());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return TmdbMovieTile(
                    movie: movie,
                    onTap: () {
                      context.push('/tmdb-movies/details', extra: movie);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

