import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/actor.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;
  final VoidCallback? onDelete;

  const ActorTile({super.key, required this.actor, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActorPhoto(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Актер',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildActorPhoto() {
    final defaultImageUrl = actor.imageUrl ?? 'https://donskoy.gosuslugi.ru/netcat_files/354/1988/net_foto_muzh.jpg';

    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: defaultImageUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}