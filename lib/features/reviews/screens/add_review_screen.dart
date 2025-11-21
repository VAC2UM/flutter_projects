import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/reviews_cubit.dart';
import '../state/reviews_state.dart';
import '../../../shared/theme/theme_state.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final reviewsCubit = state.extra as ReviewsCubit;

    return BlocProvider.value(
      value: reviewsCubit,
      child: const AddReviewView(),
    );
  }
}

class AddReviewView extends StatefulWidget {
  const AddReviewView({super.key});

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  final TextEditingController _movieTitleController = TextEditingController();
  final TextEditingController _reviewTextController = TextEditingController();
  final TextEditingController _moviePosterController = TextEditingController();

  int _rating = 3;
  String _movieId = '';

  void _submitReview(BuildContext context) {
    final movieTitle = _movieTitleController.text.trim();
    final reviewText = _reviewTextController.text.trim();

    if (movieTitle.isEmpty || reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Заполните все обязательные поля'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.error,
        ),
      );
      return;
    }

    if (_movieId.isEmpty) {
      _movieId = DateTime.now().millisecondsSinceEpoch.toString();
    }

    context.read<ReviewsCubit>().addReview(
      movieId: _movieId,
      movieTitle: movieTitle,
      rating: _rating,
      text: reviewText,
      moviePosterUrl: _moviePosterController.text.trim().isEmpty
          ? null
          : _moviePosterController.text.trim(),
    );

    context.pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отзыв на "$movieTitle" добавлен'),
        backgroundColor: ThemeState.of(context).currentTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _movieTitleController.dispose();
    _reviewTextController.dispose();
    _moviePosterController.dispose();
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
      body: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _movieTitleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Название фильма *',
                      prefixIcon: Icon(
                        Icons.movie,
                        color: themeState.currentTheme.colorScheme.primary,
                      ),
                      hintText: 'Введите название фильма',
                    ),
                  ),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _moviePosterController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'URL постера (опционально)',
                      prefixIcon: Icon(
                        Icons.image,
                        color: themeState.currentTheme.colorScheme.primary,
                      ),
                      hintText: 'https://example.com/poster.jpg',
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting ? null : () => _submitReview(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeState.currentTheme.colorScheme.primary,
                        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
          inactiveColor: themeState.currentTheme.colorScheme.primary.withOpacity(0.3),
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