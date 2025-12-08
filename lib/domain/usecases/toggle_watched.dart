import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/watchlist_item.dart';
import '../interfaces/watchlist_repository.dart';

class ToggleWatched implements UseCase<WatchlistItem, String> {
  final WatchlistRepository repository;

  ToggleWatched(this.repository);

  @override
  Future<WatchlistItem> call(String id) async {
    return await repository.toggleWatched(id);
  }
}
