import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/watchlist_bloc.dart';
import '../delegates/watchlist_event.dart';
import '../delegates/watchlist_state.dart';
import '../../movies/delegates/movies_bloc.dart';
import '../../movies/delegates/movies_state.dart';
import '../../movies/delegates/movies_event.dart';
import 'package:flutter_projects/domain/models/watchlist_item.dart';
import 'package:flutter_projects/domain/models/movie.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';

class AddWatchlistScreen extends StatelessWidget {
  const AddWatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<MoviesBloc>()..add(LoadMovies()),
      child: BlocProvider.value(
        value: locator<WatchlistBloc>(),
        child: const AddWatchlistView(),
      ),
    );
  }
}

class AddWatchlistView extends StatefulWidget {
  const AddWatchlistView({super.key});

  @override
  State<AddWatchlistView> createState() => _AddWatchlistViewState();
}

class _AddWatchlistViewState extends State<AddWatchlistView> {
  final TextEditingController _searchController = TextEditingController();

  Movie? _selectedMovie;
  List<Movie> _filteredMovies = [];
  bool _showMovieList = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMovies(String query, List<Movie> movies) {
    setState(() {
      if (query.isEmpty) {
        _filteredMovies = movies;
      } else {
        _filteredMovies = movies
            .where(
              (movie) =>
                  movie.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _showMovieList = query.isNotEmpty && _filteredMovies.isNotEmpty;
    });
  }

  void _selectMovie(Movie movie) {
    setState(() {
      _selectedMovie = movie;
      _searchController.text = movie.title;
      _showMovieList = false;
    });
  }

  void _saveMovie(BuildContext context) {
    if (_selectedMovie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Выберите фильм'),
          backgroundColor: ThemeState.of(
            context,
          ).currentTheme.colorScheme.error,
        ),
      );
      return;
    }

    final item = WatchlistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _selectedMovie!.title,
      watched: false,
      imageUrl: _selectedMovie!.imageUrl,
    );

    context.read<WatchlistBloc>().add(AddWatchlistItemEvent(item));
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return BlocListener<WatchlistBloc, WatchlistState>(
      listener: (context, state) {
        if (state is WatchlistError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is WatchlistOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить в список'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          backgroundColor: themeState.currentTheme.colorScheme.primary,
          foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        ),
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, moviesState) {
            return BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, watchlistState) {
                final List<Movie> movies = moviesState is MoviesLoaded
                    ? List<Movie>.from(moviesState.movies)
                    : [];

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Выберите фильм *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                themeState.currentTheme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Поиск фильма',
                            prefixIcon: Icon(
                              Icons.search,
                              color:
                                  themeState.currentTheme.colorScheme.primary,
                            ),
                            hintText: 'Введите название фильма',
                            suffixIcon: _selectedMovie != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _selectedMovie = null;
                                        _searchController.clear();
                                        _showMovieList = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) => _filterMovies(value, movies),
                          onTap: () {
                            if (_searchController.text.isEmpty) {
                              setState(() {
                                _filteredMovies = movies;
                                _showMovieList = movies.isNotEmpty;
                              });
                            }
                          },
                        ),
                        if (_showMovieList && _filteredMovies.isNotEmpty)
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: themeState
                                    .currentTheme
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredMovies.length,
                              itemBuilder: (context, index) {
                                final movie = _filteredMovies[index];
                                return ListTile(
                                  leading: const Icon(Icons.movie),
                                  title: Text(movie.title),
                                  subtitle: movie.year != null
                                      ? Text('${movie.year}')
                                      : null,
                                  onTap: () => _selectMovie(movie),
                                );
                              },
                            ),
                          ),
                        if (_selectedMovie != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeState
                                  .currentTheme
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: themeState
                                      .currentTheme
                                      .colorScheme
                                      .primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Выбран: ${_selectedMovie!.title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: themeState
                                          .currentTheme
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),
                        BlocBuilder<WatchlistBloc, WatchlistState>(
                          builder: (context, state) {
                            final isLimitReached =
                                state is WatchlistLoaded &&
                                state.isLimitReached;
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    isLimitReached || _selectedMovie == null
                                    ? null
                                    : () => _saveMovie(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isLimitReached || _selectedMovie == null
                                      ? themeState
                                            .currentTheme
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.12)
                                      : themeState
                                            .currentTheme
                                            .colorScheme
                                            .primary,
                                  foregroundColor:
                                      isLimitReached || _selectedMovie == null
                                      ? themeState
                                            .currentTheme
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.38)
                                      : themeState
                                            .currentTheme
                                            .colorScheme
                                            .onPrimary,
                                ),
                                child: const Text(
                                  'Добавить в список',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<WatchlistBloc, WatchlistState>(
                          builder: (context, state) {
                            if (state is WatchlistLoaded &&
                                state.isLimitReached) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  'Достигнут лимит фильмов в списке желаемого (${state.maxItems})',
                                  style: TextStyle(
                                    color: themeState
                                        .currentTheme
                                        .colorScheme
                                        .error,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
