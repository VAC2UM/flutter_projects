import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/favorites/models/favorite.dart';
import 'package:flutter_projects/features/favorites/state/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState()) {
    loadFavorites();
  }

  void loadFavorites() {
    emit(state.copyWith(isLoading: true));

    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        final initialFavorites = <Favorite>[];

        emit(FavoritesState(
          favorites: initialFavorites,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Ошибка загрузки избранных: $e',
        ));
      }
    });
  }

  void addFavorite({required String title, String? imageUrl}) {
    if (state.isLimitReached) {
      emit(state.copyWith(error: 'Нельзя добавить более ${state.maxFavorites} фильмов в избранное'));
      return;
    }

    try {
      final newFavorite = Favorite.create(title: title, imageUrl: imageUrl);
      final updatedFavorites = List<Favorite>.from(state.favorites)..add(newFavorite);

      emit(state.copyWith(
        favorites: updatedFavorites,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка добавления в избранное: $e'));
    }
  }

  void deleteFavorite(String id) {
    try {
      final updatedFavorites = List<Favorite>.from(state.favorites)
        ..removeWhere((fav) => fav.id == id);

      emit(state.copyWith(
        favorites: updatedFavorites,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка удаления из избранного: $e'));
    }
  }

  void restoreFavorite(Favorite favorite, int originalIndex) {
    try {
      final updatedFavorites = List<Favorite>.from(state.favorites)
        ..insert(originalIndex, favorite);

      emit(state.copyWith(
        favorites: updatedFavorites,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка восстановления избранного: $e'));
    }
  }

  void clearAllFavorites() {
    emit(state.copyWith(favorites: []));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  bool isFavorite(String title) {
    return state.favorites.any((fav) => fav.title == title);
  }

  void updateFavorite(String id, {String? title, String? imageUrl}) {
    try {
      final updatedFavorites = state.favorites.map((fav) {
        if (fav.id == id) {
          return Favorite(
            id: fav.id,
            title: title ?? fav.title,
            imageUrl: imageUrl ?? fav.imageUrl,
          );
        }
        return fav;
      }).toList();

      emit(state.copyWith(favorites: updatedFavorites));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка обновления избранного: $e'));
    }
  }
}