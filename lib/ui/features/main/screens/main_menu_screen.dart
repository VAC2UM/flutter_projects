import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/ui/features/auth/delegates/auth_cubit.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Актеры',
      'icon': Icons.person,
      'color': Colors.blue,
      'route': '/actors',
    },
    {
      'title': 'Фильмы',
      'icon': Icons.movie,
      'color': Colors.green,
      'route': '/movies',
    },
    {
      'title': 'Режиссеры',
      'icon': Icons.theaters,
      'color': Colors.orange,
      'route': '/directors',
    },
    {
      'title': 'Кинокомпании',
      'icon': Icons.business,
      'color': Colors.purple,
      'route': '/studios',
    },
    {
      'title': 'Избранное',
      'icon': Icons.favorite,
      'color': Colors.red,
      'route': '/favorites',
    },
    {
      'title': 'Желаемое',
      'icon': Icons.list,
      'color': Colors.amber,
      'route': '/watchlist',
    },
    {
      'title': 'Отзывы',
      'icon': Icons.reviews,
      'color': Colors.indigo,
      'route': '/reviews',
    },
    {
      'title': 'Профиль',
      'icon': Icons.person_outline,
      'color': Colors.teal,
      'route': '/profile',
    },
    {
      'title': 'Настройки',
      'icon': Icons.settings,
      'color': Colors.grey,
      'route': '/settings',
    },
  ];

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
    context.pushReplacement('/auth');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.push(_menuItems[index]['route']);
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
            tooltip: 'Выйти',
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
                color: themeState.currentTheme.colorScheme.onSurface
                    .withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return _buildMenuListItem(
                    context,
                    item['title'],
                    item['icon'],
                    item['color'],
                    () => _onItemTapped(index),
                    themeState,
                    index == _selectedIndex,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuListItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeState themeState,
    bool isSelected,
  ) {
    return Card(
      elevation: isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeState.currentTheme.colorScheme.surface,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeState.currentTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: themeState.currentTheme.colorScheme.onSurface
                    .withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
