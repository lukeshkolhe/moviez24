import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviez24/app/base/base_view.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/modules/movies/ui/movie_list/movie_list_screen_controller.dart';
import 'package:moviez24/app/modules/movies/ui/widgets/movie_card.dart';
import 'package:moviez24/app/shared_widgets/layouts/vertical_space.dart';
import 'package:moviez24/app/shared_widgets/movies_app_bar.dart';
import 'package:moviez24/app/shared_widgets/pagination/paginated_list.dart';

class MovieListScreen extends BaseView<MovieListScreenController> {
  static const String route = '/movie-list';

  MovieListScreen({super.key});

  @override
  final controller = MovieListScreenController();

  @override
  Widget build(BuildContext context) => GetBuilder(
        init: controller,
        builder: (ctrl) => Scaffold(
          appBar: MoviesAppBar(titleText: 'Trending Movies'),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: SearchBar(
                  hintText: 'Search Movie Name',
                  leading: const Icon(Icons.search),
                  controller: controller.searchInputController,
                  onChanged: controller.onSearchInputChanged,
                ),
              ),
              VerticalSpace.small(),
              Expanded(
                child: PaginatedGrid<Movie>(
                  builder: (movie, index) => MovieCard(
                    movie: movie,
                    toggleFav: () {
                      controller.toggleFavMovie(movie);
                    },
                  ),
                  emptyViewBuilder: () => Text('No Movies Found'),
                  controller: controller.paginationController,
                ),
              ),
            ],
          ),
        ),
      );
}
