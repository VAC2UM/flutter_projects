import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/watchlist_bloc.dart';
import '../delegates/watchlist_event.dart';
import '../delegates/watchlist_state.dart';
import 'package:flutter_projects/domain/models/watchlist_item.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class AddWatchlistScreen extends StatefulWidget {
  const AddWatchlistScreen({super.key});

  @override
  State<AddWatchlistScreen> createState() => _AddWatchlistScreenState();
}

class _AddWatchlistScreenState extends State<AddWatchlistScreen> {
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
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Введите название фильма'),
          backgroundColor: ThemeState.of(
            context,
          ).currentTheme.colorScheme.error,
        ),
      );
      return;
    }

    final item = WatchlistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      watched: false,
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
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
                BlocBuilder<WatchlistBloc, WatchlistState>(
                  builder: (context, state) {
                    final isLimitReached =
                        state is WatchlistLoaded && state.isLimitReached;
                    return ElevatedButton(
                      onPressed: isLimitReached
                          ? null
                          : () => _saveMovie(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLimitReached
                            ? themeState.currentTheme.colorScheme.onSurface
                                  .withOpacity(0.12)
                            : themeState.currentTheme.colorScheme.primary,
                        foregroundColor: isLimitReached
                            ? themeState.currentTheme.colorScheme.onSurface
                                  .withOpacity(0.38)
                            : themeState.currentTheme.colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Добавить в список'),
                    );
                  },
                ),
                BlocBuilder<WatchlistBloc, WatchlistState>(
                  builder: (context, state) {
                    if (state is WatchlistLoaded && state.isLimitReached) {
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
      ),
    );
  }
}
