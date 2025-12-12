import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../dto/news_article_dto.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseDto> getMoviesNews({int page = 1, int pageSize = 20});
  Future<NewsResponseDto> getTopHeadlines({String? country, String? category});
  Future<NewsResponseDto> searchNews(
    String query, {
    int page = 1,
    int pageSize = 20,
  });
  Future<NewsResponseDto> getNewsBySource(
    String source, {
    int page = 1,
    int pageSize = 20,
  });
  Future<NewsResponseDto> getNewsByDateRange(
    String from,
    String to, {
    int page = 1,
    int pageSize = 20,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '982da93d3297496aa7f80d6f759b441e';
  static const Duration _timeout = Duration(seconds: 15);

  NewsRemoteDataSourceImpl({http.Client? client})
    : client = client ?? http.Client();

  Map<String, String> get _headers => {'X-Api-Key': apiKey};

  Future<http.Response> _getWithTimeout(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    try {
      return await client
          .get(uri, headers: headers ?? _headers)
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
  Future<NewsResponseDto> getMoviesNews({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/everything?q=movies&language=ru&page=$page&pageSize=$pageSize',
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(json.decode(response.body));
      } else {
        String errorMessage = 'Не удалось загрузить новости о кино';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Ошибка сервера или неверный API ключ';
        }
        throw Exception('$errorMessage (Статус: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке новостей о кино: $e');
    }
  }

  @override
  Future<NewsResponseDto> getTopHeadlines({
    String? country,
    String? category,
  }) async {
    try {
      final countryParam = country ?? 'us';
      final categoryParam =
          category ?? 'entertainment';

      final uri = Uri.parse('$baseUrl/top-headlines').replace(
        queryParameters: {'country': countryParam, 'category': categoryParam},
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(json.decode(response.body));
      } else {
        String errorMessage = 'Не удалось загрузить топ новости';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Ошибка сервера или неверный API ключ';
        }
        throw Exception('$errorMessage (Статус: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке топ новостей: $e');
    }
  }

  @override
  Future<NewsResponseDto> searchNews(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final uri = Uri.parse(
        '$baseUrl/everything?q=$encodedQuery&language=ru&page=$page&pageSize=$pageSize',
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(json.decode(response.body));
      } else {
        String errorMessage = 'Не удалось выполнить поиск новостей';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Ошибка сервера или неверный API ключ';
        }
        throw Exception('$errorMessage (Статус: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при поиске новостей: $e');
    }
  }

  @override
  Future<NewsResponseDto> getNewsBySource(
    String source, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/everything').replace(
        queryParameters: {
          'sources': source,
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(json.decode(response.body));
      } else {
        String errorMessage = 'Не удалось загрузить новости по источнику';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Ошибка сервера или неверный API ключ';
        }
        throw Exception('$errorMessage (Статус: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке новостей по источнику: $e');
    }
  }

  @override
  Future<NewsResponseDto> getNewsByDateRange(
    String from,
    String to, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/everything?q=cinema&from=$from&to=$to&language=ru&page=$page&pageSize=$pageSize',
      );
      final response = await _getWithTimeout(uri);

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(json.decode(response.body));
      } else {
        String errorMessage = 'Не удалось загрузить новости за период';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Ошибка сервера или неверный API ключ';
        }
        throw Exception('$errorMessage (Статус: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка при загрузке новостей за период: $e');
    }
  }
}
