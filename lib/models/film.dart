// ignore_for_file: constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:linux_test/models/common.dart';

class ProductionCompany {
  late final String name;
  late final int id;
  late String? logo;
  late String? originCounty;

  ProductionCompany();
  ProductionCompany.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData["id"];
    name = jsonData["name"];
    logo = jsonData["logo_path"];
    originCounty = jsonData["origin_country"];
  }
}

class ProductionCountry {
  late String name;
  late String iso6391;

  ProductionCountry();
  ProductionCountry.fromJson(Map<String, dynamic> jsonData) {
    name = jsonData["name"];
    iso6391 = jsonData["iso_3166_1"];
  }
}

// Object for storing search and discover result from api
class ResultFilm {
  late int id;
  late MediaType type;

  String? title;
  String? originalTitle;
  String? summary;

  List<Genre> genres = [];
  String? posterPath;
  String? backdropPath;

  // Release date for movie and first air date for tv
  DateTime? releaseDate;

  String? originalLanguage;
  late num popularity;
  late int voteCount;
  late num voteAverage;

  Map<String, dynamic> jsonData = {};

  ResultFilm();
  ResultFilm.fromJson(this.jsonData, {MediaType? mediaType}) {
    id = jsonData["id"];

    posterPath = jsonData["poster_path"];
    backdropPath = jsonData["backdrop_path"];
    summary = jsonData["overview"];

    voteAverage = jsonData["vote_average"] ?? 0;
    voteCount = jsonData["vote_count"] ?? 0;
    popularity = jsonData['popularity'] ?? 0;
    originalLanguage = jsonData["original_language"];

    if (jsonData.containsKey("media_type")) {
      type = jsonData["media_type"] == "movie" ? MediaType.movie : MediaType.tv;
    } else {
      type = mediaType!;
    }

    if (type == MediaType.movie) {
      title = jsonData["title"];
      originalTitle = jsonData["original_title"];
      releaseDate = DateTime.tryParse(jsonData["release_date"] ?? "");
    } else if (type == MediaType.tv) {
      title = jsonData["name"];
      originalTitle = jsonData["original_name"];
      releaseDate = DateTime.tryParse(jsonData["first_air_date"] ?? "");
    }

    final List genreList = jsonData['genre_ids'] ?? List.empty();
    for (int gId in genreList) {
      Genre g = getGenreFromId(gId);
      genres.add(g);

      if (g == Genre.Invalid) {
        debugPrint("Unknow Genre $gId");
      }
    }
  }

  @override
  bool operator ==(other) {
    if (other is! ResultFilm) {
      return false;
    }
    if (id != other.id) return false;
    if (type != other.type) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + type.hashCode;
    return result;
  }
}

class Movie {
  late final int id;
  late final String imdbId;

  late final String title;
  late final String originalTitle;
  late String? tagLine;
  late String? summary;

  List<Genre> genres = [];

  late final DateTime? releaseDate;
  late int runtime;

  late MovieStatus status;

  late String backdropPath;
  late String posterPath;
  Map<String, String> collection = {};
  Map<ImageType, List<String>> images = {};
  Map<VideoType, List<Map>> videos = {};

  late int budget;
  late int revenue;
  late num voteAverage;
  late int voteCount;
  late num popularity;

  late List<ProductionCompany> productionCompanies = [];
  late List<ProductionCountry> productionCountries = [];

  late String? ageCertification;

  Map<String, dynamic> jsonData = {};

  late String originalLanguage;

  Movie.fromJson(this.jsonData) {
    //TODO: Support for Age certification
    id = jsonData["id"];
    imdbId = jsonData["imdb_id"];
    title = jsonData["title"];
    originalTitle = jsonData["original_title"];
    tagLine = jsonData["tagline"];
    summary = jsonData["overview"];
    budget = jsonData["budget"] ?? 0;
    revenue = jsonData["revenue"] ?? 0;
    voteCount = jsonData["vote_count"] ?? 0;
    voteAverage = jsonData["vote_average"] ?? 0;
    popularity = jsonData["popularity"] ?? 0;
    backdropPath = jsonData["backdrop_path"] ?? "";
    posterPath = jsonData["poster_path"] ?? "";
    runtime = jsonData["runtime"] ?? 0;
    releaseDate = DateTime.tryParse(jsonData["release_date"] ?? "");
    originalLanguage = jsonData["original_language"] ?? "";
    status = getMovieStatusFromName(jsonData["status"]);

    if (jsonData["belong_to_collection"] != null) {
      collection = jsonData["belong_to_collection"];
    }

    for (var genre in jsonData["genres"]) {
      genres.add(getGenreFromId(genre["id"]));
    }
    for (var company in jsonData["production_companies"]) {
      productionCompanies.add(ProductionCompany.fromJson(company));
    }
    for (var country in jsonData["production_countries"]) {
      productionCountries.add(ProductionCountry.fromJson(country));
    }

    for (var vidData in jsonData["videos"]["results"]) {
      Map d = {
        "key": vidData["key"],
        "name": vidData["name"],
        "site": vidData["site"],
        "type": vidData["type"]
      };
      switch (vidData["type"]) {
        case "Featurette":
          if (!videos.containsKey(VideoType.Featurette)) {
            videos[VideoType.Featurette] = [];
          }
          videos[VideoType.Featurette]?.add(d);
          break;
        case "Teaser":
          if (!videos.containsKey(VideoType.Teaser)) {
            videos[VideoType.Teaser] = [];
          }
          videos[VideoType.Teaser]?.add(d);
          break;
        case "Trailer":
          if (!videos.containsKey(VideoType.Trailer)) {
            videos[VideoType.Trailer] = [];
          }
          videos[VideoType.Trailer]?.add(d);
          break;
        case "Clip":
          if (!videos.containsKey(VideoType.Clip)) {
            videos[VideoType.Clip] = [];
          }
          videos[VideoType.Clip]?.add(d);
          break;
        default:
          if (!videos.containsKey(VideoType.Other)) {
            videos[VideoType.Other] = [];
          }
          videos[VideoType.Other]?.add(d);
      }
    }

    for (var type in (jsonData["images"] as Map).keys) {
      ImageType imageType;
      switch (type) {
        case "backdrops":
          imageType = ImageType.Backdrop;
          break;
        case "posters":
          imageType = ImageType.Poster;
          break;
        default:
          imageType = ImageType.Other;
      }

      for (var element in (jsonData["images"][type] as List)) {
        if (!images.containsKey(imageType)) {
          images[imageType] = [];
        }
        images[imageType]?.add(element["file_path"]);
      }
    }
  }
}

class Tv {
  late final int id;
  late final String imdbId;

  late final String title;
  late final String originalTitle;
  late String? tagLine;
  late String? summary;

  List<Genre> genres = [];

  late final DateTime? firstAirDate;
  late final DateTime? lastAirDate;

  late int? episodeRuntime;

  late MovieStatus status;

  late int totalSeasons;
  late int totalEpisodes;

  late String backdropPath;
  late String posterPath;
  Map<String, String> collection = {};
  Map<ImageType, List<String>> images = {};
  Map<VideoType, List<Map>> videos = {};

  late num voteAverage;
  late int voteCount;
  late num popularity;

  late List<ProductionCompany> productionCompanies = [];
  late List<ProductionCountry> productionCountries = [];

  late String? ageCertification;

  Map<String, dynamic> jsonData = {};

  Tv.fromJson(this.jsonData) {
    //TODO: Support for Age certification
    //TODO: Support for IMDB
    //TODO: Support for status
    id = jsonData["id"];
    // imdbId = jsonData["imdb_id"];
    title = jsonData["name"];
    originalTitle = jsonData["original_name"];
    tagLine = jsonData["tagline"];
    summary = jsonData["overview"];
    // budget = jsonData["budget"];
    // revenue = jsonData["revenue"];
    voteCount = jsonData["vote_count"] ?? 0;
    voteAverage = jsonData["vote_average"] ?? 0;
    popularity = jsonData["popularity"] ?? 0;
    backdropPath = jsonData["backdrop_path"];
    posterPath = jsonData["poster_path"];

    firstAirDate = DateTime.tryParse(jsonData["first_air_date"]);
    lastAirDate = DateTime.tryParse(jsonData["last_air_date"]);
    episodeRuntime = jsonData["episode_run_time"].length > 0
        ? jsonData["episode_run_time"][0]
        : 0;
    totalSeasons = jsonData['number_of_seasons'];
    totalEpisodes = jsonData['number_of_episodes'];

    status = getMovieStatusFromName(jsonData["status"]);
    if (status == MovieStatus.Other) {
      debugPrint("Unknow status ${jsonData['status']}");
    }

    for (var genre in jsonData["genres"]) {
      genres.add(getGenreFromId(genre["id"]));
    }
    for (var company in jsonData["production_companies"]) {
      productionCompanies.add(ProductionCompany.fromJson(company));
    }
    for (var country in jsonData["production_countries"]) {
      productionCountries.add(ProductionCountry.fromJson(country));
    }

    for (var vidData in jsonData["videos"]["results"]) {
      Map d = {
        "key": vidData["key"],
        "name": vidData["name"],
        "site": vidData["site"],
        "type": vidData["type"]
      };
      switch (vidData["type"]) {
        case "Featurette":
          if (!videos.containsKey(VideoType.Featurette)) {
            videos[VideoType.Featurette] = [];
          }
          videos[VideoType.Featurette]?.add(d);
          break;
        case "Teaser":
          if (!videos.containsKey(VideoType.Teaser)) {
            videos[VideoType.Teaser] = [];
          }
          videos[VideoType.Teaser]?.add(d);
          break;
        case "Trailer":
          if (!videos.containsKey(VideoType.Trailer)) {
            videos[VideoType.Trailer] = [];
          }
          videos[VideoType.Trailer]?.add(d);
          break;
        case "Clip":
          if (!videos.containsKey(VideoType.Clip)) {
            videos[VideoType.Clip] = [];
          }
          videos[VideoType.Clip]?.add(d);
          break;
        default:
          if (!videos.containsKey(VideoType.Other)) {
            videos[VideoType.Other] = [];
          }
          videos[VideoType.Other]?.add(d);
      }
    }

    for (var type in (jsonData["images"] as Map).keys) {
      ImageType imageType;
      switch (type) {
        case "backdrops":
          imageType = ImageType.Backdrop;
          break;
        case "posters":
          imageType = ImageType.Poster;
          break;
        default:
          imageType = ImageType.Other;
      }

      for (var element in (jsonData["images"][type] as List)) {
        if (!images.containsKey(imageType)) {
          images[imageType] = [];
        }
        images[imageType]?.add(element["file_path"]);
      }
    }
  }
}
