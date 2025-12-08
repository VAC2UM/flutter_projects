import 'package:flutter_projects/domain/models/watchlist_item.dart';

abstract class WatchlistState {
  final int maxItems;
  const WatchlistState({this.maxItems = 10});
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistItem> items;
  
  WatchlistLoaded(this.items, {super.maxItems});
  
  bool get canAddMore => items.length < maxItems;
  bool get isLimitReached => items.length >= maxItems;
  int get itemsCount => items.length;
  int get watchedCount => items.where((item) => item.watched).length;
  int get remainingCount => itemsCount - watchedCount;
}

class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message, {super.maxItems});
}

class WatchlistOperationSuccess extends WatchlistState {
  final String message;
  WatchlistOperationSuccess(this.message, {super.maxItems});
}
