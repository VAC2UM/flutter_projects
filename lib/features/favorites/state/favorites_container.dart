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

  void addFavorite(String title) {
    setState(() {
      _favorites.add(Favorite.create(title: title));
    });
  }

  void removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
