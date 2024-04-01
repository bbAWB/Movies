import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/main_page_data_controller.dart';
import 'package:flutter_application_1/model/main_page_data.dart';
import 'package:flutter_application_1/model/movie.dart';
import 'package:flutter_application_1/model/search_category.dart';
import 'package:flutter_application_1/widget/movie_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});
final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider).movies!;

  return movies.isNotEmpty ? movies[0].posterURL() : null;
});

class MainPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;
  late var selectedMoviePosterURL;
  late MainPageDataController mainPageDataController;
  late MainPageData mainPageData;
  late TextEditingController _searchTextFieldController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier); // update the page
    mainPageData = ref.watch(mainPageDataControllerProvider);
    _searchTextFieldController = TextEditingController();
    _searchTextFieldController.text = mainPageData.searchText!;
    selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SizedBox(
          height: _deviceHeight,
          width: _deviceWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [_backgroundWidget(), _forgroundWidgets()],
          ),
        ));
  }

  Widget _backgroundWidget() {
    if (selectedMoviePosterURL != null) {
      return Container(
          height: _deviceHeight,
          width: _deviceWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(selectedMoviePosterURL),
                fit: BoxFit.cover,
              )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
            ),
          ));
    } else {
      return Container(
          height: _deviceHeight, width: _deviceWidth, color: Colors.black);
    }
  }

  Widget _forgroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight! * 0.02, 0, 0),
      width: _deviceWidth! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight! * 0.83,
            padding: EdgeInsets.only(top: _deviceHeight! * 0.01),
            child: _moviesListViewWidget(),
          )
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight! * 0.07,
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _searchFieldWidget(),
            _categorySelctionWidget(),
          ],
        ),
      ),
    );
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none;
    return Expanded(
      child: SizedBox(
        child: TextField(
            controller: _searchTextFieldController,
            onSubmitted: (input) =>
                mainPageDataController.updateTextSearch(input),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                focusedBorder: border,
                border: border,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white24,
                ),
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
                filled: false,
                fillColor: Colors.white24,
                hintText: 'Search......')),
      ),
    );
  }

  Widget _categorySelctionWidget() {
    return DropdownButton(
      dropdownColor: const Color.fromARGB(96, 184, 111, 111),
      value: mainPageData!.searchCategory,
      icon: const Padding(
        padding: EdgeInsets.only(right: 6.0),
        child: Icon(
          Icons.menu,
          color: Colors.white24,
        ),
      ),
      underline: Container(
        height: 2,
        color: Colors.white24,
      ),
      onChanged: (value) => value.toString().isNotEmpty
          ? mainPageDataController?.updateSearchCatergory(value!)
          : null,
      items: const [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> movies = mainPageData.movies!;

    if (movies.length != 0) {
      return NotificationListener(
          onNotification: (dynamic onScrollNotification) {
            if (onScrollNotification is ScrollEndNotification) {
              final before = onScrollNotification.metrics.extentBefore;
              final max = onScrollNotification.metrics.maxScrollExtent;
              if (before == max) {
                mainPageDataController.getMovies();
                return true;
              }
              return false;
            }
            return false;
          },
          child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int count) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: _deviceHeight! * 0.02, horizontal: 0),
                  child: GestureDetector(
                    onTap: () {
                      selectedMoviePosterURL.state = movies[count].posterURL();
                    },
                    child: MovieTile(
                        movie: movies[count],
                        height: _deviceHeight! * 0.20,
                        width: _deviceWidth! * 0.85),
                  ),
                );
              }));
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
