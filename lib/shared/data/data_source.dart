import 'package:flutter_projects/features/actors/actors_feature.dart';
import 'package:flutter_projects/features/movies/models/movie.dart';
import 'package:flutter_projects/features/profile/models/user.dart';

class AppData {
  final List<Actor> actors;
  final List<Movie> movies;
  final List<Movie> favorites;
  final List<Movie> watchlist;
  final User currentUser;

  AppData({
    required this.actors,
    required this.movies,
    required this.favorites,
    required this.watchlist,
    required this.currentUser,
  });

  factory AppData.initial() {
    final actors = [
      Actor(id: '1', name: 'Юра Борисов', imageUrl: 'https://static1.tgstat.ru/channels/_0/66/66d1a80fb5e8f400a2ddd816cc92ad95.jpg'),
      Actor(id: '2', name: 'Хоакин Феникс', imageUrl: 'https://images.iptv.rt.ru/images/cpt8sk3ir4sqiatbcj90.jpg'),
      Actor(id: '3', name: 'Брайан Крэнстон', imageUrl: 'https://avatars.mds.yandex.net/i?id=ad1cff5319fcd4bc26ae7ab9aa63e091_l-5387132-images-thumbs&n=13'),
    ];

    final movies = [
      Movie(
        id: '1',
        title: 'Мстители: Финал',
        rating: 8,
        imageUrl: 'https://a.ltrbxd.com/resized/film-poster/2/2/6/6/6/0/226660-avengers-endgame-0-2000-0-3000-crop.jpg?v=d4006bfd5e',
        director: 'Братья Руссо',
        year: 2019,
        genre: 'Фантастика',
      ),
      Movie(
        id: '2',
        title: 'Кентавр',
        rating: 7,
        imageUrl: 'https://a.ltrbxd.com/resized/film-poster/1/0/2/9/9/1/0/1029910-centaur-2023-0-2000-0-3000-crop.jpg?v=fe28759575',
        director: 'Кирилл Кемниц',
        year: 2023,
        genre: 'Драма',
      ),
    ];

    final currentUser = User(
      id: '1',
      name: 'Иван Петров',
      email: 'ivan.petrov@example.com',
      avatarUrl: 'https://i.pinimg.com/originals/d7/92/04/d79204dc601b615a329ea4c679adb481.jpg',
      joinDate: DateTime(2025, 11, 14),
    );

    return AppData(
      actors: actors,
      movies: movies,
      favorites: [movies[0]],
      watchlist: [movies[1]],
      currentUser: currentUser,
    );
  }

  AppData copyWith({
    List<Actor>? actors,
    List<Movie>? movies,
    List<Movie>? favorites,
    List<Movie>? watchlist,
    User? currentUser,
  }) {
    return AppData(
      actors: actors ?? this.actors,
      movies: movies ?? this.movies,
      favorites: favorites ?? this.favorites,
      watchlist: watchlist ?? this.watchlist,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  AppData updateUserStatistics() {
    final updatedUser = currentUser.copyWith(
      favoriteMoviesCount: favorites.length,
      watchlistCount: watchlist.length,
    );

    return copyWith(currentUser: updatedUser);
  }

  AppData updateUserProfile(User newUser) {
    return copyWith(currentUser: newUser);
  }
}