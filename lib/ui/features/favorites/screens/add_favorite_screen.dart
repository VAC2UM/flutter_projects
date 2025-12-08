import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/favorites_bloc.dart';
import '../delegates/favorites_event.dart';
import '../delegates/favorites_state.dart';
import 'package:flutter_projects/domain/models/favorite.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class AddFavoriteScreen extends StatefulWidget {
  const AddFavoriteScreen({super.key});

  @override
  State<AddFavoriteScreen> createState() => _AddFavoriteScreenState();
}

class _AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveFavorite(BuildContext context) {
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

    final favorite = Favorite(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
    );

    context.read<FavoritesBloc>().add(AddFavoriteEvent(favorite));
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is FavoritesOperationSuccess) {
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
          title: const Text('Добавить в избранное'),
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
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    final isLimitReached =
                        state is FavoritesLoaded && state.isLimitReached;
                    return ElevatedButton(
                      onPressed: isLimitReached
                          ? null
                          : () => _saveFavorite(context),
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
                      child: const Text('Добавить в избранное'),
                    );
                  },
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoaded && state.isLimitReached) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Достигнут лимит избранных фильмов (${state.maxFavorites})',
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
