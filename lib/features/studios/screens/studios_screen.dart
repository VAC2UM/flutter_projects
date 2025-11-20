import 'package:flutter/material.dart';
import 'package:flutter_projects/features/studios/models/studio.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';
import 'package:flutter_projects/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class StudiosScreen extends StatefulWidget {
  const StudiosScreen({super.key});

  @override
  State<StudiosScreen> createState() => _StudiosScreenState();
}

class _StudiosScreenState extends State<StudiosScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    List<Studio> studios = [];
    if (locator.isRegistered<AppData>()) {
      final appData = locator<AppData>();
      studios = appData.studios;
    } else {
      print('Ошибка: AppData не зарегистрирован в GetIt!');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кинокомпании'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: studios.isEmpty
          ? EmptyState(
        icon: Icons.business,
        title: 'Список кинокомпаний пуст',
        subtitle: 'Необходимо добавить кинокомпании',
        themeState: themeState,
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: studios.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final studio = studios[index];
          return _StudioTile(studio: studio);
        },
      ),
    );
  }
}

class _StudioTile extends StatelessWidget {
  final Studio studio;

  const _StudioTile({required this.studio});

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
          _buildStudioLogo(themeState),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studio.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeState.currentTheme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                if (studio.foundedYear != null || studio.country != null)
                  Text(
                    '${studio.foundedYear != null ? 'Основана в ${studio.foundedYear}' : ''}${studio.foundedYear != null && studio.country != null ? ' • ' : ''}${studio.country ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                if (studio.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    studio.description!,
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

  Widget _buildStudioLogo(ThemeState themeState) {
    final defaultImageUrl = studio.logoUrl ?? 'https://via.placeholder.com/80x80/6c757d/ffffff?text=LOGO';

    return Container(
      width: 80,
      height: 80,
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
                Icons.business,
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