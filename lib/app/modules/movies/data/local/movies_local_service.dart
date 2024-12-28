import 'dart:convert';

import 'package:moviez24/app/base/services/local/base_local_service.dart';
import 'package:moviez24/utils/consts/storage_consts.dart';

class MoviesLocalService extends BaseLocalService {
  Future<List<int>> getFavoriteMovieIDs() async {
    final String? s =
        await localStorageUtil.read(key: StorageConsts.FavoriteMovieIDs);
    if (s == null) return [];
    return (jsonDecode(s) as List).map((id) => id as int).toList();
  }

  Future<void> saveFavoriteMovie(int id) async {
    final List<int> savedFavoriteMovieIDs = await getFavoriteMovieIDs();

    if (savedFavoriteMovieIDs.contains(id)) return;

    savedFavoriteMovieIDs.add(id);
    await localStorageUtil.write(
      key: StorageConsts.FavoriteMovieIDs,
      value: getEncodedList(savedFavoriteMovieIDs),
    );
  }

  Future<void> removeFavoriteMovie(int id) async {
    final List<int> savedFavoriteMovieIDs = await getFavoriteMovieIDs();

    savedFavoriteMovieIDs.remove(id);

    localStorageUtil.write(
      key: StorageConsts.FavoriteMovieIDs,
      value: getEncodedList(savedFavoriteMovieIDs),
    );
  }

  String getEncodedList(List<int> savedFavoriteMovieIDs) =>
      jsonEncode(savedFavoriteMovieIDs);
}
