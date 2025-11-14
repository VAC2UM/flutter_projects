import 'package:flutter/material.dart';
import 'package:flutter_projects/features/movies/models/movie.dart';
import 'package:flutter_projects/features/profile/screens/profile_screen.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/auth/screens/auth_screen.dart';
import 'package:flutter_projects/features/main/screens/main_menu_screen.dart';
import 'package:flutter_projects/features/actors/screens/actors_screen.dart';
import 'package:flutter_projects/features/movies/screens/movies_list_screen.dart';
import 'package:flutter_projects/features/favorites/screens/favorites_screen.dart';
import 'package:flutter_projects/features/watchlist/screens/watchlist_screen.dart';
import 'package:flutter_projects/features/settings/settings_feature.dart';
import 'package:flutter_projects/features/actors/state/actors_container.dart';
import 'package:flutter_projects/features/movies/state/movies_container.dart';
import 'package:flutter_projects/features/favorites/state/favorites_container.dart';
import 'package:flutter_projects/features/watchlist/state/watchlist_container.dart';
import 'package:flutter_projects/features/movies/screens/movie_details_screen.dart';
import 'package:flutter_projects/features/actors/screens/add_actor_screen.dart';
import 'package:flutter_projects/features/movies/screens/add_movie_screen.dart';
import 'package:flutter_projects/features/favorites/screens/add_favorite_screen.dart';
import 'package:flutter_projects/features/watchlist/screens/add_watchlist_screen.dart';
import 'shared/app_theme.dart';
import 'shared/theme/theme_state.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),

    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) => const MainMenuScreen(),
    ),

    GoRoute(
      path: '/actors',
      name: 'actors',
      builder: (context, state) => const ActorsScreen(),
    ),
    GoRoute(
      path: '/actors/add',
      name: 'addActor',
      builder: (context, state) => const AddActorScreen(),
    ),

    GoRoute(
      path: '/movies',
      name: 'movies',
      builder: (context, state) => MoviesContainer(
        child: MoviesListScreen(movies: locator<AppData>().movies),
      ),
    ),
    GoRoute(
      path: '/movies/add',
      name: 'addMovie',
      builder: (context, state) => const AddMovieScreen(),
    ),
    GoRoute(
      path: '/movies/details',
      name: 'movieDetails',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailsScreen(movie: movie);
      },
    ),

    // Favorites Section
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesContainer(
        child: FavoritesScreen(),
      ),
    ),
    GoRoute(
      path: '/favorites/add',
      name: 'addFavorite',
      builder: (context, state) => const AddFavoriteScreen(),
    ),

    // Watchlist Section
    GoRoute(
      path: '/watchlist',
      name: 'watchlist',
      builder: (context, state) => const WatchlistContainer(
        child: WatchlistScreen(),
      ),
    ),
    GoRoute(
      path: '/watchlist/add',
      name: 'addWatchlist',
      builder: (context, state) => const AddWatchlistScreen(),
    ),

    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeState(
      isDarkMode: _isDarkMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp.router(
        title: 'Фильмотека',
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}