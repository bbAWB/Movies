import 'package:flutter_application_1/model/movie.dart';
import 'package:flutter_application_1/model/search_category.dart';

class MainPageData {
  final List<Movie>? movies;
  final int? page;
  final String? searchCategory;
  final String? searchText;

  MainPageData({
    required this.movies,
    required this.page,
    required this.searchCategory,
    required this.searchText,
  });

  MainPageData.initial() // Corrected method name
      : movies = [],
        page = 1,
        searchCategory = SearchCategory.popular,
        searchText = '';

  MainPageData copyWith({
    List<Movie>? movies,
    int? page,
    String? searchCategory,
    String? searchText,
  }) {
    return MainPageData(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      searchCategory: searchCategory ?? this.searchCategory,
      searchText: searchText ?? this.searchText,
    );
  }
}
