import 'package:moviez24/app/base/services/remote/base_remote_service.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/modules/movies/domain/models/request/get_movie_request.dart';
import 'package:moviez24/app/shared_widgets/pagination/models/pagination_details.dart';
import 'package:moviez24/utils/network/api_request.dart';
import 'package:moviez24/utils/network/endpoints.dart';
import 'package:moviez24/utils/network/result.dart';

class MoviesRemoteService extends BaseRemoteService {
  Future<Result<List<Movie>, PaginationDetails>> getMovies(
          GetMoviesRequest request) async =>
      ApiRequest<List<Movie>, PaginationDetails>(
              endpoint: ApiEndpoints.trendingMoviesAPI,
              requestMethod: RequestMethod.get,
              headers: await headers,
              queryParameters: request.json,
              listParser: Movie.fromJsonList,
              metaParser: PaginationDetails.fromJson)
          .perform();
}
