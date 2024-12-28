import 'package:moviez24/app/modules/movies/data/movies_repository.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/modules/movies/domain/models/request/get_movie_request.dart';
import 'package:moviez24/app/shared_widgets/pagination/models/pagination_details.dart';
import 'package:moviez24/utils/network/result.dart';

abstract class MoviesRepository {
  static MoviesRepository get instance => MoviesRepositoryImpl();

  Future<Result<List<Movie>, PaginationDetails>> getMovies(GetMoviesRequest request);

  Future<Result<bool, void>> saveFavoriteMovie(Movie movie);

  Future<Result<bool, void>> removeFavoriteMovie(Movie movie);
}
