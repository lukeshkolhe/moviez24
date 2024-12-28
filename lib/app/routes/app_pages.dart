import 'package:moviez24/app/modules/movies/ui/movie_list/movie_list_screen.dart';
import 'package:moviez24/app/routes/app_page.dart';

class AppPages {
  static const initial = MovieListScreen.route;

  static final routes = [
    AppPage(
      name: MovieListScreen.route,
      page: () => MovieListScreen(),
    ),
  ];
}
