import 'package:flutter/material.dart';
import 'package:flutter_projects/features/directors/models/director.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class DirectorsScreen extends StatefulWidget {
  const DirectorsScreen({super.key});

  @override
  State<DirectorsScreen> createState() => _DirectorsScreenState();
}

class _DirectorsScreenState extends State<DirectorsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    List<Director> directors = [];
    if (locator.isRegistered<AppData>()) {
      final appData = locator<AppData>();
      directors = appData.directors;
    } else {
      print('Ошибка: AppData не зарегистрирован в GetIt!');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Режиссеры'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: directors.isEmpty
          ? EmptyState(
        icon: Icons.person,
        title: 'Список режиссеров пуст',
        subtitle: 'Необходимо добавить режиссеров',
        themeState: themeState,
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: directors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final director = directors[index];
          return _DirectorTile(director: director);
        },
      ),
    );
  }
}

class _DirectorTile extends StatelessWidget {
  final Director director;

  const _DirectorTile({required this.director});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeState.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: themeState.currentTheme.colorScheme.outline.withOpacity(0.3)),
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
          _buildDirectorPhoto(themeState),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  director.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeState.currentTheme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                if (director.birthYear != null || director.country != null)
                  Text(
                    '${director.birthYear != null ? 'Род. ${director.birthYear}' : ''}${director.birthYear != null && director.country != null ? ' • ' : ''}${director.country ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                if (director.biography != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    director.biography!,
                    style: TextStyle(
                      fontSize: 12,
                      color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectorPhoto(ThemeState themeState) {
    final defaultImageUrl = director.imageUrl ?? 'https://donskoy.gosuslugi.ru/netcat_files/354/1988/net_foto_muzh.jpg';

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
        child: Image.network(
          defaultImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: themeState.currentTheme.colorScheme.surfaceVariant,
            child: Center(
              child: Icon(
                Icons.person,
                color: themeState.currentTheme.colorScheme.onSurfaceVariant,
                size: 40,
              ),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: themeState.currentTheme.colorScheme.surfaceVariant,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: themeState.currentTheme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}