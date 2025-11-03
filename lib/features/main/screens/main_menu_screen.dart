import 'package:flutter/material.dart';
import 'package:flutter_projects/features/auth/screens/auth_screen.dart';
import 'package:flutter_projects/features/favorites/favorites_feature.dart';
import 'package:flutter_projects/features/movies/movies_feature.dart';
import 'package:flutter_projects/features/watchlist/screens/watchlist_screen.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_container.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import '../../actors/actors_feature.dart';
import '../../actors/state/actors_container.dart';
import '../../settings/settings_feature.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
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
            const Text(
              'Добро пожаловать!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Выберите раздел для просмотра:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

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
                        () => _navigateToScreen(
                      context,
                      ActorsContainer(
                        child: ActorsScreen(actors: AppData.actors),
                      ),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    'Фильмы',
                    Icons.movie,
                    Colors.deepPurple,
                        () => _navigateToScreen(
                      context,
                      MoviesContainer(
                        child: MoviesListScreen(movies: AppData.movies),
                      ),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    'Избранное',
                    Icons.favorite,
                    Colors.deepOrange,
                        () => _navigateToScreen(
                      context,
                      FavoritesContainer(
                        child: FavoritesScreen(),
                      ),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    'Желаемое',
                    Icons.list,
                    Colors.green,
                        () => _navigateToScreen(
                      context,
                      WatchlistContainer(
                        child: WatchlistScreen(),
                      ),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    'Настройки',
                    Icons.settings,
                    Colors.black,
                        () => _navigateToScreen(
                      context,
                      const SettingsScreen(),
                    ),
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
