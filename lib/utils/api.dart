import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum ImageWidth { original, w92, w154, w185, w342, w500 }

class MovieApi {
  static const String apiKey = "api_key=a3ca43df787ec6b692b7e1e2d53a65ec";
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String searchUrl = "${baseUrl}search/movie?$apiKey&query=";
  static const String imageUrl = "https://image.tmdb.org/t/p/";

  static Future<List<dynamic>> searchMovies(String query,
      {int page = 1}) async {
    final resp = await http.get(Uri.parse("$searchUrl$query&page=$page"));
    return jsonDecode(resp.body)["results"];
  }

  static Future<List<dynamic>> getTrendMovies({int page = 1}) async {
    String trendUrl = "${baseUrl}trending/movie/week?$apiKey&page=$page";
    final resp = await http.get(Uri.parse(trendUrl));
    return jsonDecode(resp.body)["results"];
  }

  static String getImageLink(String url,
      {ImageWidth width = ImageWidth.original}) {
    return imageUrl + width.name + url;
  }
}
