import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/actors/actors_feature.dart';
import 'package:flutter_projects/features/actors/state/actors_container.dart';
import 'shared/app_theme.dart';
import 'features/movies/movies_feature.dart';
import 'features/watchlist/watchlist_feature.dart';
import 'features/favorites/favorites_feature.dart';
import 'features/settings/settings_feature.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/actors',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
          title: 'Моя информация',
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/actors',
          name: 'actors',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ActorsContainer(child: ActorsScreen()),
          ),
        ),
        GoRoute(
          path: '/movies',
          name: 'movies',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MoviesContainer(child: MoviesListScreen()),
          ),
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoritesContainer(child: FavoritesScreen()),
          ),
        ),
        GoRoute(
          path: '/watchlist',
          name: 'watchlist',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WatchlistContainer(child: WatchlistScreen()),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Фильмотека',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.contains('/actors')) return 0;
    if (location.contains('/movies')) return 1;
    if (location.contains('/favorites')) return 2;
    if (location.contains('/watchlist')) return 3;
    if (location.contains('/settings')) return 4;

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/actors');
        break;
      case 1:
        context.go('/movies');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/watchlist');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(index, context),
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