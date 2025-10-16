import 'package:flutter/material.dart';
import '../models/watchlist_item.dart';

class WatchlistContainer extends StatefulWidget {
  final Widget child;

  const WatchlistContainer({super.key, required this.child});

  @override
  State<WatchlistContainer> createState() => _WatchlistContainerState();

  static _WatchlistContainerState of(BuildContext context) {
    return context.findAncestorStateOfType<_WatchlistContainerState>()!;
  }
}

class _WatchlistContainerState extends State<WatchlistContainer> {
  final List<WatchlistItem> _watchlist = [];

  List<WatchlistItem> get watchlist => List.unmodifiable(_watchlist);

  void addMovie(String title) {
    setState(() {
      _watchlist.add(WatchlistItem.create(title: title, watched: false));
    });
  }

  void toggleWatched(int index) {
    setState(() {
      _watchlist[index] = _watchlist[index].copyWith(
        watched: !_watchlist[index].watched,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
