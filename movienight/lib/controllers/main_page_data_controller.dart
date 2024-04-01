import 'package:flutter_application_1/model/main_page_data.dart';
import 'package:flutter_application_1/model/movie.dart';
import 'package:flutter_application_1/model/search_category.dart';
import 'package:flutter_application_1/services/movie_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }
  final MovieService _movieService = GetIt.instance.get<MovieService>();
  Future<void> getMovies() async {
    try {
      List<Movie>? movies = [];
      if (state.searchText!.isEmpty ?? true) {
        if (state.searchCategory == SearchCategory.popular) {
          movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          movies = await _movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          movies = [];
        }
      } else {
        movies = (await _movieService.searchMovies(state.searchText ?? ''));
      }
      if (movies != null) {
        List<Movie> nonNullMovies = movies.whereType<Movie>().toList();
        state = state.copyWith(
            movies: [...state.movies!, ...nonNullMovies],
            page: state.page! + 1);
      }
    } catch (e, stackTrace) {
      print('Error fetching movies: $e');
      print(stackTrace);
    }
  }

  void updateSearchCatergory(String category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String _searchtext) {
    try {
      state = state.copyWith(
        movies: [],
        page: 1,
        searchCategory: SearchCategory.none,
        searchText: _searchtext,
      );
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
