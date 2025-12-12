import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../dto/tmdb_movie_dto.dart';
import '../dto/tmdb_actor_dto.dart';
import '../dto/tmdb_recommendations_dto.dart';

abstract class TmdbRemoteDataSource {
  Future<TmdbMoviesResponseDto> getPopularMovies({int page = 1});
  Future<TmdbMovieDto> getMovieById(int movieId);
  Future<TmdbCreditsDto> getMovieCredits(int movieId);
  Future<TmdbMoviesResponseDto> searchMovies(String query, {int page = 1});
  Future<TmdbRecommendationsResponseDto> getMovieRecommendations(
    int movieId, {
    int page = 1,
  });
}

class TmdbRemoteDataSourceImpl implements TmdbRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'fd02c1ced8916dc5e64e3e4bdaa64a88';
  static const Duration _timeout = Duration(seconds: 15);

  TmdbRemoteDataSourceImpl({http.Client? client})
    : client = client ?? http.Client();

  Future<http.Response> _getWithTimeout(Uri uri) async {
    try {
      return await client
          .get(uri)
          .timeout(
            _timeout,
            onTimeout: () {
              throw TimeoutException(
                'Запрос превысил время ожидания (${_timeout.inSeconds} секунд)',
                _timeout,
              );
            },
          );
    } on TimeoutException catch (e) {
      throw Exception(e.message ?? 'Запрос превысил время ожидания');
    } on SocketException catch (e) {
      throw Exception(
        'Ошибка подключения к серверу. Проверьте интернет-соединение.\n${e.message}',
      );
    } on HttpException catch (e) {
      throw Exception('Ошибка HTTP: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  @override
  Future<TmdbMoviesResponseDto> getPopularMovies({int page = 1}) async {
    try {
      final uri = Uri.parse('$baseUrl/movie/popular').replace(
        queryParameters: {
          'api_key': apiKey,
          'page': page.toString(),
          'language': 'ru-RU',
        },
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return TmdbMoviesResponseDto.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Не удалось загрузить популярные фильмы: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке популярных фильмов: $e');
    }
  }

  @override
  Future<TmdbMovieDto> getMovieById(int movieId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/movie/$movieId',
      ).replace(queryParameters: {'api_key': apiKey, 'language': 'ru-RU'});
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return TmdbMovieDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Не удалось загрузить фильм: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке фильма: $e');
    }
  }

  @override
  Future<TmdbCreditsDto> getMovieCredits(int movieId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/movie/$movieId/credits',
      ).replace(queryParameters: {'api_key': apiKey, 'language': 'ru-RU'});
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return TmdbCreditsDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Не удалось загрузить актеров: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке актеров: $e');
    }
  }

  @override
  Future<TmdbMoviesResponseDto> searchMovies(
    String query, {
    int page = 1,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search/movie').replace(
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'page': page.toString(),
          'language': 'ru-RU',
        },
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return TmdbMoviesResponseDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Не удалось выполнить поиск: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при поиске фильмов: $e');
    }
  }

  @override
  Future<TmdbRecommendationsResponseDto> getMovieRecommendations(
    int movieId, {
    int page = 1,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/movie/$movieId/recommendations').replace(
        queryParameters: {
          'api_key': apiKey,
          'page': page.toString(),
          'language': 'ru-RU',
        },
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return TmdbRecommendationsResponseDto.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception(
          'Не удалось загрузить рекомендации: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке рекомендаций: $e');
    }
  }
}
