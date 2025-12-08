import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/reviews_cubit.dart';
import '../delegates/reviews_state.dart';
import '../../movies/delegates/movies_bloc.dart';
import '../../movies/delegates/movies_state.dart';
import '../../movies/delegates/movies_event.dart';
import 'package:flutter_projects/domain/models/movie.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<MoviesBloc>()..add(LoadMovies()),
      child: BlocProvider.value(
        value: locator<ReviewsCubit>(),
        child: const AddReviewView(),
      ),
    );
  }
}

class AddReviewView extends StatefulWidget {
  const AddReviewView({super.key});

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reviewTextController = TextEditingController();

  int _rating = 3;
  Movie? _selectedMovie;
  List<Movie> _filteredMovies = [];
  bool _showMovieList = false;

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

  Future<void> _submitReview(BuildContext context) async {
    final reviewText = _reviewTextController.text.trim();

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

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Введите текст отзыва'),
          backgroundColor: ThemeState.of(
            context,
          ).currentTheme.colorScheme.error,
        ),
      );
      return;
    }

    await context.read<ReviewsCubit>().addReview(
      movieId: _selectedMovie!.id,
      movieTitle: _selectedMovie!.title,
      rating: _rating,
      text: reviewText,
      moviePosterUrl: _selectedMovie!.imageUrl,
    );

    if (context.mounted) {
    context.pop();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отзыв на "${_selectedMovie!.title}" добавлен'),
        backgroundColor: ThemeState.of(
          context,
        ).currentTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _reviewTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый отзыв'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, moviesState) {
          return BlocBuilder<ReviewsCubit, ReviewsState>(
            builder: (context, reviewsState) {
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
                          color: themeState.currentTheme.colorScheme.onSurface,
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
                        color: themeState.currentTheme.colorScheme.primary,
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
                              color: themeState.currentTheme.colorScheme.outline
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
                                color:
                                    themeState.currentTheme.colorScheme.primary,
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
                  const SizedBox(height: 24),
                  _buildRatingSection(themeState),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _reviewTextController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Текст отзыва *',
                      alignLabelWithHint: true,
                      hintText: 'Напишите ваш отзыв на фильм...',
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                          onPressed: reviewsState.isSubmitting
                          ? null
                          : () => _submitReview(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themeState.currentTheme.colorScheme.primary,
                        foregroundColor:
                            themeState.currentTheme.colorScheme.onPrimary,
                      ),
                          child: reviewsState.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                            )
                          : const Text(
                              'Добавить отзыв',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRatingSection(ThemeState themeState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Оценка: $_rating/5',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _rating.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _rating.toString(),
          activeColor: themeState.currentTheme.colorScheme.primary,
          inactiveColor: themeState.currentTheme.colorScheme.primary
              .withOpacity(0.3),
          onChanged: (double value) {
            setState(() {
              _rating = value.round();
            });
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
      ],
    );
  }
}
