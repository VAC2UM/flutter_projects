import 'package:flutter/foundation.dart';
import 'package:flutter_projects/features/watchlist/models/watchlist_item.dart';

@immutable
class WatchlistState {
  final List<WatchlistItem> items;
  final bool isLoading;
  final String? error;
  final int maxItems;

  const WatchlistState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.maxItems = 10,
  });

  bool get canAddMore => items.length < maxItems;
  bool get isLimitReached => items.length >= maxItems;
  int get itemsCount => items.length;
  int get watchedCount => items.where((item) => item.watched).length;
  int get remainingCount => itemsCount - watchedCount;

  WatchlistState copyWith({
    List<WatchlistItem>? items,
    bool? isLoading,
    String? error,
    int? maxItems,
  }) {
    return WatchlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      maxItems: maxItems ?? this.maxItems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WatchlistState &&
        listEquals(other.items, items) &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.maxItems == maxItems;
  }

  @override
  int get hashCode => Object.hash(items, isLoading, error, maxItems);
}