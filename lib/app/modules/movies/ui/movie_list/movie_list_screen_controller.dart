import 'package:moviez24/app/base/base_controller.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/modules/movies/domain/models/request/get_movie_request.dart';
import 'package:moviez24/app/modules/movies/domain/movies_repository.dart';
import 'package:moviez24/app/shared_widgets/pagination/paginated_list_controller.dart';

class MovieListScreenController extends BaseController {
  final repository = MoviesRepository.instance;

  late final paginationController = PaginatedListController<Movie>(
    onDataRequested: (pagination) =>
        repository.getMovies(GetMoviesRequest(paginationDetails: pagination)),
  );

  toggleFavMovie(Movie movie) {
    if (movie.isFavorite) {
      _removeFromFav(movie);
    } else {
      _addToFav(movie);
    }
    movie.isFavorite = !movie.isFavorite;
    update();
  }

  _addToFav(Movie movie) {
    repository.saveFavoriteMovie(movie);
  }

  _removeFromFav(Movie movie) {
    repository.removeFavoriteMovie(movie);
  }
}
