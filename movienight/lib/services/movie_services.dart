import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/movie.dart';
import 'package:flutter_application_1/services/http_service.dart';
import 'package:get_it/get_it.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  HTTPService? _http;

  MovieService() {
    // Assuming HTTPService is registered with GetIt
    _http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response? response = await _http!.get('/movie/popular', query: {
      'page': page,
    });

    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response? response = await _http!.get('/movie/upcoming', query: {
      'page': page,
    });

    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load upComing Movies.');
    }
  }

  Future<List<Movie>?> searchMovies(String? searchTerm, {int? page}) async {
    if (searchTerm == null || searchTerm.isEmpty) {
      throw Exception('Search term cannot be null or empty');
    }

    Response? response = await _http!.get('/search/movie', query: {
      'query': searchTerm,
      'page': page,
    });

    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie>? movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Invalid data format for movie search');
    }
  }
}
