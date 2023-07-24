// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linux_test/models/common.dart';

class MovieApi {
  static const String apiKey = "api_key=a3ca43df787ec6b692b7e1e2d53a65ec";
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String imageUrl = "https://image.tmdb.org/t/p/";
  static const String ytImgUrl = "https://img.youtube.com/vi/";
  static const String vimeoImgUrl = "https://vimeo.com/";

  //#region Utils

  static String getImageLink(String path,
      {ImageWidth width = ImageWidth.original}) {
    return imageUrl + width.name + path;
  }

  static String getVideoThumbailLink(Map videoData) {
    if (videoData["site"] == "YouTube") {
      return "$ytImgUrl${videoData["key"]}/mqdefault.jpg";
    }
    return "";
  }
  //#endregion

//#region Public Api Calls
  static Future<List<dynamic>> searchMovies(String query,
      {int page = 1}) async {
    return _search("movie", query, page);
  }

  static Future<List<dynamic>> search(String query, {int page = 1}) async {
    return _search("multi", query, page);
  }

  static Future<List<dynamic>> searchTV(String query, {int page = 1}) async {
    return _search("tv", query, page);
  }

  static Future<Map<String, dynamic>> getMovie(String id) async {
    return _get("movie", id);
  }

  static Future<Map<String, dynamic>> getTv(String id) async {
    return _get("tv", id);
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

  static Future<Map> getMovieImages(String movID) async {
    return _getImages("movie", movID);
  }

  static Future<Map> getTvImages(String movID) async {
    return _getImages("tv", movID);
  }

  static Future<Map<String, List>> getMovieVideos(String movID) async {
    return _getVideos("movie", movID);
  }

  static Future<Map<String, List>> getTvVideos(String movID) async {
    return _getVideos("tv", movID);
  }

  static Future<Map> getMovieCast(String movID) async {
    return _getCast("movie", movID);
  }

  static Future<Map> getTvCast(String movID) async {
    return _getCast("tv", movID);
  }
//#Endregion

//#region Private Api Calls
  static Future<Map<String, dynamic>> _get(String type, String id) async {
    String url = "$baseUrl$type/$id?$apiKey&append_to_response=videos,images";
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
    final resp = await http.get(
        Uri.parse("${baseUrl}search/$type?$apiKey&query=$query&page=$page"));
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

    while (filterMovs.length < 20 && page < 100) {
      String url = "${baseUrl}discover/$type?$apiKey&page=$page";
      var resp = await http.get(Uri.parse(url));
      page++;
      List mov = jsonDecode(resp.body)["results"];

      filterMovs.addAll(mov.where(
          (element) => element['genre_ids'].contains(getGenreId(genre))));
    }
    return filterMovs;
  }

  static Future<Map> _getImages(String type, String movID) async {
    String url = "$baseUrl$type/$movID/images?$apiKey";
    var resp = await http.get(Uri.parse(url));
    return jsonDecode(resp.body);
  }

  static Future<Map<String, List>> _getVideos(String type, String movID) async {
    String url = "$baseUrl$type/$movID/videos?$apiKey";
    Map<String, List> vidData = {
      "Trailer": [],
      "Teaser": [],
      "Featurette": [],
      "Behind the Scenes": []
    };

    var resp = await http.get(Uri.parse(url));
    List rawData = jsonDecode(resp.body)["results"];

    for (var i in rawData) {
      vidData[i['type']]?.add(i);
    }
    return vidData;
  }

  static Future<Map> _getCast(String type, String movID) async {
    String url = "$baseUrl$type/$movID/credits?$apiKey";

    var resp = await http.get(Uri.parse(url));
    return jsonDecode(resp.body);
  }
//#endregion
}
