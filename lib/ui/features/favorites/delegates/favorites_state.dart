import 'package:flutter_projects/domain/models/favorite.dart';

abstract class FavoritesState {
  final int maxFavorites;
  const FavoritesState({this.maxFavorites = 4});
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;
  
  FavoritesLoaded(this.favorites, {super.maxFavorites});
  
  bool get canAddMore => favorites.length < maxFavorites;
  bool get isLimitReached => favorites.length >= maxFavorites;
  int get favoritesCount => favorites.length;
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message, {super.maxFavorites});
}

class FavoritesOperationSuccess extends FavoritesState {
  final String message;
  FavoritesOperationSuccess(this.message, {super.maxFavorites});
}
