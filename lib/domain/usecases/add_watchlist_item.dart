import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/watchlist_item.dart';
import '../interfaces/watchlist_repository.dart';

class AddWatchlistItem implements UseCase<WatchlistItem, WatchlistItem> {
  final WatchlistRepository repository;

  AddWatchlistItem(this.repository);

  @override
  Future<WatchlistItem> call(WatchlistItem item) async {
    return await repository.addItem(item);
  }
}
