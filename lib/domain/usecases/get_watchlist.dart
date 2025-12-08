import 'package:flutter_projects/core/usecases/usecase.dart';
import '../models/watchlist_item.dart';
import '../interfaces/watchlist_repository.dart';

class GetWatchlist implements UseCase<List<WatchlistItem>, NoParams> {
  final WatchlistRepository repository;

  GetWatchlist(this.repository);

  @override
  Future<List<WatchlistItem>> call(NoParams params) async {
    return await repository.getWatchlist();
  }
}
