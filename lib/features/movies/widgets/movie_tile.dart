import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onDelete;

  const MovieTile({super.key, required this.movie, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(movie.id),
      child: ListTile(
        leading: const Icon(Icons.movie, color: Colors.deepPurple),
        title: Text(movie.title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(
          'Рейтинг: ${movie.rating}/10',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
