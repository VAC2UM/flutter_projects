import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'features/movies/movies_feature.dart';
import 'features/watchlist/watchlist_feature.dart';
import 'features/favorites/favorites_feature.dart';
import 'features/profile/profile_feature.dart';
import 'features/settings/settings_feature.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фильмотека',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MyHomePage(title: 'Моя информация'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const ProfileContainer(child: ProfileScreen());
      case 1:
        return const MoviesContainer(child: MoviesListScreen());
      case 2:
        return const FavoritesContainer(child: FavoritesScreen());
      case 3:
        return const WatchlistContainer(child: WatchlistScreen());
      case 4:
        return const SettingsScreen();
      default:
        return const ProfileContainer(child: ProfileScreen());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Актеры'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Фильмы'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Желаемое'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
