import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/watchlist_item.dart';

class WatchlistItemTile extends StatelessWidget {
  final WatchlistItem item;
  final ValueChanged<bool>? onChanged;

  const WatchlistItemTile({super.key, required this.item, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildMoviePoster(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: item.watched ? Colors.grey : Colors.green[800],
                        decoration: item.watched ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusBadge(),
                  ],
                ),
              ),
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  value: item.watched,
                  onChanged: onChanged != null ? (value) => onChanged!(value!) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.green;
                      }
                      return Colors.grey;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster() {
    final defaultImageUrl = item.imageUrl ?? 'https://avatars.mds.yandex.net/i?id=2834d31489c7357b9f67b9489064ecafb1fd8a03-12601053-images-thumbs&n=13';

    return Container(
      width: 70,
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
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: defaultImageUrl,
              fit: BoxFit.cover,
              width: 70,
              height: 100,
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
                    Icons.movie,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            if (item.watched)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.watched ? Colors.grey[200] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.watched ? Colors.grey : Colors.green[200]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.watched ? Icons.check_circle : Icons.schedule,
            size: 14,
            color: item.watched ? Colors.grey : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            item.watched ? 'Просмотрено' : 'К просмотру',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: item.watched ? Colors.grey : Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }
}