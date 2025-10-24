import 'package:flutter/material.dart';
import '../models/favorite.dart';

class FavoritesContainer extends StatefulWidget {
  final Widget child;

  const FavoritesContainer({super.key, required this.child});

  @override
  State<FavoritesContainer> createState() => _FavoritesContainerState();

  static _FavoritesContainerState of(BuildContext context) {
    return context.findAncestorStateOfType<_FavoritesContainerState>()!;
  }
}

class _FavoritesContainerState extends State<FavoritesContainer> {
  final List<Favorite> _favorites = [];

  List<Favorite> get favorites => List.unmodifiable(_favorites);

  void addFavorite({required String title, String? imageUrl}) {
    setState(() {
      _favorites.add(Favorite.create(title: title, imageUrl: imageUrl));
    });
  }

  void deleteFavorite(BuildContext context, String id, VoidCallback onUpdated) {
    final index = _favorites.indexWhere((fav) => fav.id == id);
    if (index == -1) return;

    final removed = _favorites[index];
    setState(() {
      _favorites.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удалён из избранного: ${removed.title}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            _restoreFavorite(removed, index);
            onUpdated();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    onUpdated();
  }

  void _restoreFavorite(Favorite favorite, int index) {
    setState(() {
      _favorites.insert(index, favorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}