// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum ImageWidth { original, w92, w154, w185, w342, w500 }

enum Genre {
  Action,
  Adventure,
  Animation,
  Comedy,
  Crime,
  Documentary,
  Drama,
  Family,
  Fantasy,
  History,
  Horror,
  Music,
  Mystery,
  Romance,
  Science_Fiction,
  TV_Movie,
  Thriller,
  War,
  Western,
  Invalid
}

class MovieApi {
  static const String apiKey = "api_key=a3ca43df787ec6b692b7e1e2d53a65ec";
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String imageUrl = "https://image.tmdb.org/t/p/";

  static const Map<int, Genre> genreList = {
    28: Genre.Action,
    12: Genre.Adventure,
    16: Genre.Animation,
    35: Genre.Comedy,
    80: Genre.Crime,
    99: Genre.Documentary,
    18: Genre.Drama,
    10751: Genre.Family,
    14: Genre.Fantasy,
    36: Genre.History,
    27: Genre.Horror,
    10402: Genre.Music,
    9648: Genre.Mystery,
    10749: Genre.Romance,
    878: Genre.Science_Fiction,
    10770: Genre.TV_Movie,
    53: Genre.Thriller,
    10752: Genre.War,
    37: Genre.Western
  };

//Region Utils
  static Genre getGenreFromId(int id) {
    return genreList[id] ?? Genre.Invalid;
  }

  static int getGenreId(Genre genre) {
    return genreList.keys.firstWhere((k) => genreList[k] == genre);
  }

  static String getImageLink(String url,
      {ImageWidth width = ImageWidth.original}) {
    return imageUrl + width.name + url;
  }
//EndRegion

//Region Public Api Calls
  static Future<List<dynamic>> searchMovies(String query,
      {int page = 1}) async {
    return _search("movie", query, page);
  }

  static Future<List<dynamic>> searchTV(String query, {int page = 1}) async {
    return _search("tv", query, page);
  }

  static Future<Map> getMovie(String id) async
  {
    return _get("movie",id);
  }
  static Future<Map> getTv(String id) async
  {
    return _get("tv",id);
  }

  static Future<List<dynamic>> getTrendMovies({int page = 1}) async {
    return _getTrend("movie", page);
  }

  static Future<List<dynamic>> getTrendTV({int page = 1}) async {
    return _getTrend("tv", page);
  }

  static Future<List<dynamic>> getPopularMovies({int page = 1}) async {
    return _getPopular("movie", page);
  }

  static Future<List<dynamic>> getPopularTV({int page = 1}) async {
    return _getPopular("tv", page);
  }

  static Future<List<dynamic>> getRecentMoviesByGenre(Genre genre,
      {int page = 1}) async {
    return _getRecentByGenre("movie", genre, page);
  }

  static Future<List<dynamic>> getRecentTvByGenre(Genre genre,
      {int page = 1}) async {
    return _getRecentByGenre("tv", genre, page);
  }
//Endregion

  static Future<Map> _get(String type,String id) async {
    String url = "$baseUrl$type/$id?$apiKey";
    final resp = await http.get(Uri.parse(url));
    return jsonDecode(resp.body);
  }

  static Future<List<dynamic>> _getTrend(String type, int page) async {
    String trendUrl = "${baseUrl}trending/$type/week?$apiKey&page=$page";
    final resp = await http.get(Uri.parse(trendUrl));
    return jsonDecode(resp.body)["results"];
  }

  static Future<List<dynamic>> _search(
      String type, String query, int page) async {
    final resp = await http
        .get(Uri.parse("${baseUrl}search/$type?$apiKey$query&page=$page"));
    return jsonDecode(resp.body)["results"];
  }

  static Future<List<dynamic>> _getPopular(String type, int page) async {
    String trendUrl = "$baseUrl$type/popular?$apiKey&page=$page";
    final resp = await http.get(Uri.parse(trendUrl));
    return jsonDecode(resp.body)["results"];
  }

  static Future<List<dynamic>> _getRecentByGenre(
      String type, Genre genre, int page) async {
    List filterMovs = [];

    while (filterMovs.length < 20) {
      String url = "${baseUrl}discover/$type?$apiKey&page=$page";
      var resp = await http.get(Uri.parse(url));
      page++;
      List mov = jsonDecode(resp.body)["results"];

      filterMovs.addAll(mov.where(
          (element) => element['genre_ids'].contains(getGenreId(genre))));
    }
    return filterMovs;
  }
}
