import 'package:linux_test/models/film.dart';

class User {
  late int userId;

  Map<ResultFilm, DateTime> watchList = {};
  Map<ResultFilm, DateTime> watched = {};

  User(this.userId);

  bool addMovieToWatchlist(ResultFilm film) {
    if (!watchList.containsKey(film)) {
      watchList[film] = DateTime.now();
      return true;
    }
    return false;
  }

  bool removeMovieFromWatchlist(ResultFilm film) {
    if (watchList.containsKey(film)) {
      watchList.remove(film);
      return true;
    }
    return false;
  }

  bool addMovieToWatched(ResultFilm film) {
    if (!watched.containsKey(film)) {
      watched[film] = DateTime.now();
      removeMovieFromWatchlist(film);
      return true;
    }
    return false;
  }

  bool removeMovieFromWatched(ResultFilm film) {
    if (watched.containsKey(film)) {
      watched.remove(film);
      return true;
    }
    return false;
  }
}
