import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/tmdb_movies_bloc.dart';
import '../delegates/tmdb_movies_event.dart';
import '../delegates/tmdb_movies_state.dart';
import '../widgets/tmdb_movie_tile.dart';
import '../../../shared/empty_state.dart';
import '../../../shared/theme_state.dart';

class SearchMoviesScreen extends StatefulWidget {
  const SearchMoviesScreen({super.key});

  @override
  State<SearchMoviesScreen> createState() => _SearchMoviesScreenState();
}

class _SearchMoviesScreenState extends State<SearchMoviesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<TmdbMoviesBloc>().add(SearchMovies(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите название фильма',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<TmdbMoviesBloc, TmdbMoviesState>(
              builder: (context, state) {
                if (state is TmdbMoviesInitial) {
                  return Center(
                    child: Text(
                      'Введите запрос для поиска',
                      style: TextStyle(
                        color: themeState
                            .currentTheme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  );
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
                          onPressed: _performSearch,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TmdbMoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off,
                      title: 'Ничего не найдено',
                      subtitle: 'Попробуйте другой запрос',
                      themeState: themeState,
                    );
                  }

                  return ListView.builder(
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
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

