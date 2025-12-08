import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/core/usecases/usecase.dart';
import 'package:flutter_projects/domain/usecases/get_watchlist.dart';
import 'package:flutter_projects/domain/usecases/add_watchlist_item.dart';
import 'package:flutter_projects/domain/usecases/delete_watchlist_item.dart';
import 'package:flutter_projects/domain/usecases/toggle_watched.dart';
import 'package:flutter_projects/domain/interfaces/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlist getWatchlist;
  final AddWatchlistItem addWatchlistItem;
  final DeleteWatchlistItem deleteWatchlistItem;
  final ToggleWatched toggleWatched;
  final WatchlistRepository repository;

  WatchlistBloc({
    required this.getWatchlist,
    required this.addWatchlistItem,
    required this.deleteWatchlistItem,
    required this.toggleWatched,
    required this.repository,
  }) : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddWatchlistItemEvent>(_onAddWatchlistItem);
    on<DeleteWatchlistItemEvent>(_onDeleteWatchlistItem);
    on<ToggleWatchedEvent>(_onToggleWatched);
    on<ClearAllWatchlistItems>(_onClearAllWatchlistItems);
    on<ClearWatchedItems>(_onClearWatchedItems);
  }

  Future<void> _onLoadWatchlist(LoadWatchlist event, Emitter<WatchlistState> emit) async {
    emit(WatchlistLoading());
    try {
      final items = await getWatchlist(NoParams());
      emit(WatchlistLoaded(items));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onAddWatchlistItem(AddWatchlistItemEvent event, Emitter<WatchlistState> emit) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      if (currentState.isLimitReached) {
        emit(WatchlistError('Нельзя добавить более ${currentState.maxItems} фильмов в список желаемого'));
        return;
      }
    }

    try {
      await addWatchlistItem(event.item);
      emit(WatchlistOperationSuccess('Фильм добавлен в список желаемого'));
      add(LoadWatchlist());
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onDeleteWatchlistItem(DeleteWatchlistItemEvent event, Emitter<WatchlistState> emit) async {
    try {
      await deleteWatchlistItem(event.id);
      emit(WatchlistOperationSuccess('Фильм удален'));
      add(LoadWatchlist());
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onToggleWatched(ToggleWatchedEvent event, Emitter<WatchlistState> emit) async {
    try {
      await toggleWatched(event.id);
      add(LoadWatchlist());
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onClearAllWatchlistItems(ClearAllWatchlistItems event, Emitter<WatchlistState> emit) async {
    try {
      await repository.clearAllItems();
      emit(WatchlistOperationSuccess('Все фильмы удалены'));
      add(LoadWatchlist());
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onClearWatchedItems(ClearWatchedItems event, Emitter<WatchlistState> emit) async {
    try {
      await repository.clearWatchedItems();
      emit(WatchlistOperationSuccess('Просмотренные фильмы удалены'));
      add(LoadWatchlist());
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}
