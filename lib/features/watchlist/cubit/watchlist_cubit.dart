import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/watchlist/models/watchlist_item.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(const WatchlistState()) {
    loadWatchlist();
  }

  void loadWatchlist() {
    emit(state.copyWith(isLoading: true));

    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        final initialItems = <WatchlistItem>[];

        emit(WatchlistState(
          items: initialItems,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Ошибка загрузки списка желаемого: $e',
        ));
      }
    });
  }

  void addItem({required String title, String? imageUrl}) {
    if (state.isLimitReached) {
      emit(state.copyWith(error: 'Нельзя добавить более ${state.maxItems} фильмов в список желаемого'));
      return;
    }

    try {
      final newItem = WatchlistItem.create(
        title: title,
        watched: false,
        imageUrl: imageUrl,
      );
      final updatedItems = List<WatchlistItem>.from(state.items)..add(newItem);

      emit(state.copyWith(
        items: updatedItems,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка добавления в список желаемого: $e'));
    }
  }

  void toggleWatched(String id) {
    try {
      final updatedItems = state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(watched: !item.watched);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка изменения статуса просмотра: $e'));
    }
  }

  void deleteItem(String id) {
    try {
      final updatedItems = List<WatchlistItem>.from(state.items)
        ..removeWhere((item) => item.id == id);

      emit(state.copyWith(
        items: updatedItems,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка удаления из списка желаемого: $e'));
    }
  }

  void updateItem(String id, {String? title, String? imageUrl}) {
    try {
      final updatedItems = state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(
            title: title ?? item.title,
            imageUrl: imageUrl ?? item.imageUrl,
          );
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка обновления элемента: $e'));
    }
  }

  void clearAllItems() {
    emit(state.copyWith(items: []));
  }

  void clearWatchedItems() {
    final updatedItems = state.items.where((item) => !item.watched).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  bool isInWatchlist(String title) {
    return state.items.any((item) => item.title == title);
  }
}