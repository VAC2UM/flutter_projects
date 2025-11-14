import 'package:flutter/material.dart';
import 'package:flutter_projects/features/auth/state/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/theme_state.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  void _logout(BuildContext context) {
    AuthState.logout();
    context.pushReplacement('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Профиль',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Выйти из профиля',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Добро пожаловать!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeState.currentTheme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Выберите раздел для просмотра:',
              style: TextStyle(
                fontSize: 16,
                color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuButton(
                    context,
                    'Актеры',
                    Icons.person,
                    Colors.blue,
                        () => context.push('/actors'),
                    themeState,
                  ),
                  _buildMenuButton(
                    context,
                    'Фильмы',
                    Icons.movie,
                    Colors.green,
                        () => context.push('/movies'),
                    themeState,
                  ),
                  _buildMenuButton(
                    context,
                    'Избранное',
                    Icons.favorite,
                    Colors.red,
                        () => context.push('/favorites'),
                    themeState,
                  ),
                  _buildMenuButton(
                    context,
                    'Желаемое',
                    Icons.list,
                    Colors.orange,
                        () => context.push('/watchlist'),
                    themeState,
                  ),
                  _buildMenuButton(
                    context,
                    'Профиль',
                    Icons.person_outline,
                    Colors.purple,
                        () => context.push('/profile'),
                    themeState,
                  ),
                  _buildMenuButton(
                    context,
                    'Настройки',
                    Icons.settings,
                    Colors.grey,
                        () => context.push('/settings'),
                    themeState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ThemeState themeState,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeState.currentTheme.colorScheme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}