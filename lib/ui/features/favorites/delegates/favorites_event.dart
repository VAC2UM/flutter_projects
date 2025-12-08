import 'package:flutter_projects/domain/models/favorite.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final Favorite favorite;
  AddFavoriteEvent(this.favorite);
}

class DeleteFavoriteEvent extends FavoritesEvent {
  final String id;
  DeleteFavoriteEvent(this.id);
}

class ClearAllFavorites extends FavoritesEvent {}
