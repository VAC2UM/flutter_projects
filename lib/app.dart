import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/ui/features/auth/delegates/auth_cubit.dart';
import 'package:flutter_projects/ui/features/auth/delegates/auth_state.dart';
import 'package:flutter_projects/ui/features/directors/screens/directors_screen.dart';
import 'package:flutter_projects/ui/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter_projects/ui/features/profile/screens/profile_screen.dart';
import 'package:flutter_projects/ui/features/reviews/screens/add_review_screen.dart';
import 'package:flutter_projects/ui/features/reviews/screens/reviews_screen.dart';
import 'package:flutter_projects/ui/features/profile/delegates/profile_cubit.dart';
import 'package:flutter_projects/ui/features/settings/delegates/settings_cubit.dart';
import 'package:flutter_projects/ui/features/settings/delegates/settings_state.dart';
import 'package:flutter_projects/ui/features/studios/screens/studios_screen.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/ui/features/auth/screens/auth_screen.dart';
import 'package:flutter_projects/ui/features/main/screens/main_menu_screen.dart';
import 'package:flutter_projects/ui/features/actors/screens/actors_screen.dart';
import 'package:flutter_projects/ui/features/movies/screens/movies_list_screen.dart';
import 'package:flutter_projects/ui/features/favorites/screens/favorites_screen.dart';
import 'package:flutter_projects/ui/features/watchlist/screens/watchlist_screen.dart';
import 'package:flutter_projects/ui/features/settings/screens/settings_screen.dart';
import 'package:flutter_projects/ui/features/actors/screens/add_actor_screen.dart';
import 'package:flutter_projects/ui/features/movies/screens/add_movie_screen.dart';
import 'package:flutter_projects/ui/features/favorites/screens/add_favorite_screen.dart';
import 'package:flutter_projects/ui/features/watchlist/screens/add_watchlist_screen.dart';
import 'package:flutter_projects/ui/features/movies/screens/movie_details_screen.dart';
import 'package:flutter_projects/domain/models/movie.dart';
import 'package:flutter_projects/ui/features/movies/delegates/movies_bloc.dart';
import 'package:flutter_projects/ui/features/movies/delegates/movies_event.dart';
import 'package:flutter_projects/ui/features/favorites/delegates/favorites_bloc.dart';
import 'package:flutter_projects/ui/features/favorites/delegates/favorites_event.dart';
import 'package:flutter_projects/ui/features/watchlist/delegates/watchlist_bloc.dart';
import 'package:flutter_projects/ui/features/watchlist/delegates/watchlist_event.dart';
import 'ui/shared/app_theme.dart';
import 'ui/shared/theme_state.dart';

class _AuthNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;
  late final StreamSubscription _subscription;

  _AuthNotifier(this._authCubit) {
    _subscription = _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
  initialLocation: '/auth',
    refreshListenable: _AuthNotifier(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuth = authState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation == '/auth';

      // Если пользователь авторизован и пытается зайти на страницу авторизации - перенаправляем на главную
      if (isAuth && isGoingToAuth) {
        return '/main';
      }

      // Если пользователь не авторизован и пытается зайти не на страницу авторизации - перенаправляем на авторизацию
      if (!isAuth && !isGoingToAuth) {
        return '/auth';
      }

      return null; // Разрешаем навигацию
    },
  routes: [
    GoRoute(
      path: '/auth',
      name: 'auth',
        builder: (context, state) {
          // Передаем AuthCubit через extra
          return BlocProvider.value(
            value: authCubit,
            child: const AuthScreen(),
          );
        },
    ),

    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) => const MainMenuScreen(),
    ),

    // Actors Section
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

    // Movies Section
    GoRoute(
      path: '/movies',
      name: 'movies',
      builder: (context, state) {
        final bloc = locator<MoviesBloc>();
        bloc.add(LoadMovies());
          return BlocProvider.value(
            value: bloc,
            child: const MoviesListScreen(),
          );
      },
    ),
    GoRoute(
      path: '/movies/add',
      name: 'addMovie',
      builder: (context, state) {
        final bloc = locator<MoviesBloc>();
        return BlocProvider.value(value: bloc, child: const AddMovieScreen());
      },
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
      builder: (context, state) {
        final bloc = locator<FavoritesBloc>();
        bloc.add(LoadFavorites());
          return BlocProvider.value(
            value: bloc,
            child: const FavoritesScreen(),
          );
      },
    ),
    GoRoute(
      path: '/favorites/add',
      name: 'addFavorite',
      builder: (context, state) {
        final bloc = locator<FavoritesBloc>();
        return BlocProvider.value(
          value: bloc,
          child: const AddFavoriteScreen(),
        );
      },
    ),

    // Watchlist Section
    GoRoute(
      path: '/watchlist',
      name: 'watchlist',
      builder: (context, state) {
        final bloc = locator<WatchlistBloc>();
        bloc.add(LoadWatchlist());
          return BlocProvider.value(
            value: bloc,
            child: const WatchlistScreen(),
          );
      },
    ),
    GoRoute(
      path: '/watchlist/add',
      name: 'addWatchlist',
      builder: (context, state) {
        final bloc = locator<WatchlistBloc>();
        return BlocProvider.value(
          value: bloc,
          child: const AddWatchlistScreen(),
        );
      },
    ),

    // Settings Section
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Profile Section
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      name: 'editProfile',
      builder: (context, state) {
        final extra = state.extra;
        return extra != null
            ? BlocProvider.value(
                value: extra as ProfileCubit,
                child: const EditProfileScreen(),
              )
            : const EditProfileScreen();
      },
    ),

    GoRoute(
      path: '/studios',
      name: 'studios',
      builder: (context, state) => const StudiosScreen(),
    ),

    GoRoute(
      path: '/directors',
      name: 'directors',
      builder: (context, state) => const DirectorsScreen(),
    ),

    GoRoute(
      path: '/reviews',
      name: 'reviews',
      builder: (context, state) => const ReviewsScreen(),
    ),
    GoRoute(
      path: '/reviews/add',
      name: 'addReview',
      builder: (context, state) {
          // ReviewsCubit будет создан в AddReviewScreen если нужно
          return const AddReviewScreen();
      },
    ),
  ],
);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
    _router = createRouter(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        bloc: _authCubit,
        builder: (context, authState) {
          return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return ThemeState(
            isDarkMode: settingsState.isDarkMode,
            toggleTheme: () {
              context.read<SettingsCubit>().toggleTheme();
            },
            child: MaterialApp.router(
              title: 'Фильмотека',
              theme: settingsState.isDarkMode
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            ),
              );
            },
          );
        },
      ),
    );
  }
}
