import 'package:flutter_projects/core/usecases/usecase.dart';
import '../interfaces/watchlist_repository.dart';

class DeleteWatchlistItem implements UseCase<void, String> {
  final WatchlistRepository repository;

  DeleteWatchlistItem(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteItem(id);
  }
}
