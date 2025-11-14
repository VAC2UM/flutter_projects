import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_state.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class AddWatchlistScreen extends StatelessWidget {
  const AddWatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final watchlistCubit = state.extra as WatchlistCubit;

    return BlocProvider.value(
      value: watchlistCubit,
      child: const AddWatchlistView(),
    );
  }
}

class AddWatchlistView extends StatefulWidget {
  const AddWatchlistView({super.key});

  @override
  State<AddWatchlistView> createState() => _AddWatchlistViewState();
}

class _AddWatchlistViewState extends State<AddWatchlistView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveMovie(BuildContext context) {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      context.pop({
        'title': title,
        'imageUrl': _imageUrlController.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Введите название фильма'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить в список'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
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
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
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
              BlocBuilder<WatchlistCubit, WatchlistState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isLimitReached ? null : () => _saveMovie(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isLimitReached
                          ? themeState.currentTheme.colorScheme.onSurface.withOpacity(0.12)
                          : themeState.currentTheme.colorScheme.primary,
                      foregroundColor: state.isLimitReached
                          ? themeState.currentTheme.colorScheme.onSurface.withOpacity(0.38)
                          : themeState.currentTheme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Добавить в список'),
                  );
                },
              ),
              BlocBuilder<WatchlistCubit, WatchlistState>(
                builder: (context, state) {
                  if (state.isLimitReached) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Достигнут лимит фильмов в списке желаемого (${state.maxItems})',
                        style: TextStyle(
                          color: themeState.currentTheme.colorScheme.error,
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
      ),
    );
  }
}