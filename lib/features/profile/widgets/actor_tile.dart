import 'package:flutter/material.dart';
import '../models/actor.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;
  final VoidCallback? onDelete;

  const ActorTile({super.key, required this.actor, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(actor.name, style: const TextStyle(fontSize: 16)),
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
