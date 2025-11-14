import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/features/favorites/models/favorite.dart';

@immutable
class FavoritesState {
  final List<Favorite> favorites;
  final bool isLoading;
  final String? error;
  final int maxFavorites;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.maxFavorites = 4,
  });

  bool get canAddMore => favorites.length < maxFavorites;
  bool get isLimitReached => favorites.length >= maxFavorites;
  int get favoritesCount => favorites.length;

  FavoritesState copyWith({
    List<Favorite>? favorites,
    bool? isLoading,
    String? error,
    int? maxFavorites,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      maxFavorites: maxFavorites ?? this.maxFavorites,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoritesState &&
        listEquals(other.favorites, favorites) &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.maxFavorites == maxFavorites;
  }

  @override
  int get hashCode => Object.hash(favorites, isLoading, error, maxFavorites);
}