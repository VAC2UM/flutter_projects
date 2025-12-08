import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/core/usecases/usecase.dart';
import 'package:flutter_projects/domain/usecases/get_favorites.dart';
import 'package:flutter_projects/domain/usecases/add_favorite.dart';
import 'package:flutter_projects/domain/usecases/delete_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final DeleteFavorite deleteFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.deleteFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<DeleteFavoriteEvent>(_onDeleteFavorite);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favorites = await getFavorites(NoParams());
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAddFavorite(AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      if (currentState.isLimitReached) {
        emit(FavoritesError('Нельзя добавить более ${currentState.maxFavorites} фильмов в избранное'));
        return;
      }
    }

    try {
      await addFavorite(event.favorite);
      emit(FavoritesOperationSuccess('Фильм добавлен в избранное'));
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onDeleteFavorite(DeleteFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      await deleteFavorite(event.id);
      emit(FavoritesOperationSuccess('Фильм удален из избранного'));
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onClearAllFavorites(ClearAllFavorites event, Emitter<FavoritesState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      for (final favorite in currentState.favorites) {
        try {
          await deleteFavorite(favorite.id);
        } catch (e) {
          emit(FavoritesError('Ошибка при удалении: $e'));
          return;
        }
      }
      emit(FavoritesOperationSuccess('Все избранные фильмы удалены'));
      add(LoadFavorites());
    }
  }
}
