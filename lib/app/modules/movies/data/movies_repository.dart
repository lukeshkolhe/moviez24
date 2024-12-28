import 'package:moviez24/app/modules/movies/data/local/movies_local_service.dart';
import 'package:moviez24/app/modules/movies/data/remote/movies_remote_service.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/modules/movies/domain/models/request/get_movie_request.dart';
import 'package:moviez24/app/modules/movies/domain/movies_repository.dart';
import 'package:moviez24/app/shared_widgets/pagination/models/pagination_details.dart';
import 'package:moviez24/utils/network/result.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final remoteService = MoviesRemoteService();
  final localService = MoviesLocalService();

  @override
  Future<Result<List<Movie>, PaginationDetails>> getMovies(
      GetMoviesRequest request) async {
    final result = await remoteService.getMovies(request);
    if (result.isSuccess) {
      final favoriteIds = await localService.getFavoriteMovieIDs();
      for (final movie in result.data) {
        if (favoriteIds.contains(movie.id)) {
          movie.isFavorite = true;
        }
      }
    }
    return result;
  }

  @override
  Future<Result<bool, void>> removeFavoriteMovie(Movie movie) async {
    await localService.removeFavoriteMovie(movie.id);
    return Result<bool, void>.fromData(true);
  }

  @override
  Future<Result<bool, void>> saveFavoriteMovie(Movie movie) async {
    await localService.saveFavoriteMovie(movie.id);
    return Result<bool, void>.fromData(true);
  }
}
