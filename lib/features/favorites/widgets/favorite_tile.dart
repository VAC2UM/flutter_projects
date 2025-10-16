import 'package:flutter/material.dart';
import '../models/favorite.dart';

class FavoriteTile extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback? onDelete;

  const FavoriteTile({super.key, required this.favorite, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(favorite.title, style: const TextStyle(fontSize: 16)),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
