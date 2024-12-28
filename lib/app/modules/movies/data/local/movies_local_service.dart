import 'dart:convert';

import 'package:moviez24/app/base/services/local/base_local_service.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/utils/consts/storage_consts.dart';

class MoviesLocalService extends BaseLocalService {
  Future<List<Movie>> getFavoriteMovies() async {
    final String? s =
        await localStorageUtil.read(key: StorageConsts.FavoriteMovie);
    if (s == null) return [];
    return (jsonDecode(s) as List).map((json) => Movie.fromJson(json)).toList();
  }

  Future<void> saveFavoriteMovie(Movie movie) async {
    final List<Movie> savedFavoriteMovies = await getFavoriteMovies();

    if (savedFavoriteMovies.any((m) => m.id == movie.id)) return;

    savedFavoriteMovies.add(movie);
    await localStorageUtil.write(
      key: StorageConsts.FavoriteMovie,
      value: getEncodedList(savedFavoriteMovies),
    );
  }

  Future<void> removeFavoriteMovie(Movie movie) async {
    final List<Movie> savedFavoriteMovies = await getFavoriteMovies();

    savedFavoriteMovies.removeWhere((m) => m.id == movie.id);

    localStorageUtil.write(
      key: StorageConsts.FavoriteMovie,
      value: getEncodedList(savedFavoriteMovies),
    );
  }

  String getEncodedList(List<Movie> savedFavoriteMovie) =>
      jsonEncode(savedFavoriteMovie.map((movie) => movie.json).toList());
}
