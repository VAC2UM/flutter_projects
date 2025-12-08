import 'package:flutter_projects/domain/models/watchlist_item.dart';

abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {}

class AddWatchlistItemEvent extends WatchlistEvent {
  final WatchlistItem item;
  AddWatchlistItemEvent(this.item);
}

class DeleteWatchlistItemEvent extends WatchlistEvent {
  final String id;
  DeleteWatchlistItemEvent(this.id);
}

class ToggleWatchedEvent extends WatchlistEvent {
  final String id;
  ToggleWatchedEvent(this.id);
}

class ClearAllWatchlistItems extends WatchlistEvent {}

class ClearWatchedItems extends WatchlistEvent {}
