import 'package:flutter/material.dart';
import '../models/watchlist_item.dart';

class WatchlistItemTile extends StatelessWidget {
  final WatchlistItem item;
  final ValueChanged<bool>? onChanged;

  const WatchlistItemTile({super.key, required this.item, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(item.title),
      value: item.watched,
      onChanged: onChanged != null ? (value) => onChanged!(value!) : null,
    );
  }
}
