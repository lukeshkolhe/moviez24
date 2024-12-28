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
  Future<Result<List<Movie>, PaginationDetails>> getMovies(GetMoviesRequest request) =>
      remoteService.getMovies(request);
}
