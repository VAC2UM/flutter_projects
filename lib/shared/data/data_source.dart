import 'package:flutter_projects/features/actors/actors_feature.dart';
import 'package:flutter_projects/features/movies/models/movie.dart';
import 'package:flutter_projects/features/watchlist/models/watchlist_item.dart';

class AppData {
  static final List<Actor> actors = [
    Actor(id: '1', name: 'Юра Борисов', imageUrl: 'https://static1.tgstat.ru/channels/_0/66/66d1a80fb5e8f400a2ddd816cc92ad95.jpg'),
    Actor(id: '2', name: 'Хоакин Феникс', imageUrl: 'https://images.iptv.rt.ru/images/cpt8sk3ir4sqiatbcj90.jpg'),
    Actor(id: '3', name: 'Брайан Крэнстон', imageUrl: 'https://avatars.mds.yandex.net/i?id=ad1cff5319fcd4bc26ae7ab9aa63e091_l-5387132-images-thumbs&n=13'),
  ];

  static final List<Movie> movies = [
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
}