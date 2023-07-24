// ignore_for_file: constant_identifier_names

enum ImageWidth { original, w92, w154, w185, w342, w500 }

enum MediaType { movie, tv }

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
  Invalid,
  Kids,
  Action_Adventure,
  News,
  Reality,
  SciFi_Fantasy,
  Soap,
  Talk,
  War_Politics
}

enum MovieStatus {
  Rumored,
  Planned,
  In_Production,
  Post_Production,
  Released,
  Canceled,
  Other
}

enum ImageType { Poster, Backdrop, Other }

enum VideoType { Featurette, Trailer, Teaser, Clip, Other }

// Invalid for 10759, 10765
const Map<int, Genre> _genreList = {
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
  37: Genre.Western,
  10759: Genre.Action_Adventure,
  10762: Genre.Kids,
  10763: Genre.News,
  10764: Genre.Reality,
  10765: Genre.SciFi_Fantasy,
  10766: Genre.Soap,
  10767: Genre.Talk,
  10768: Genre.War_Politics,
};

const Map<String, MovieStatus> _movieStatusList = {
  "Rumored": MovieStatus.Rumored,
  "Canceled": MovieStatus.Canceled,
  "In Production": MovieStatus.In_Production,
  "Planned": MovieStatus.Planned,
  "Post Production": MovieStatus.Post_Production,
  "Released": MovieStatus.Released
};

Genre getGenreFromId(int id) {
  return _genreList[id] ?? Genre.Invalid;
}

int getGenreId(Genre genre) {
  return _genreList.keys.firstWhere((k) => _genreList[k] == genre);
}

MovieStatus getMovieStatusFromName(String name) {
  return _movieStatusList[name] ?? MovieStatus.Other;
}

String getFormatedReleaseDate(DateTime? date) {
  if (date == null) {
    return "";
  }
  String s = "";
  switch (date.month) {
    case DateTime.january:
      s += "Jan";
      break;
    case DateTime.february:
      s += "Feb";
      break;

    case DateTime.march:
      s += "Mar";
      break;

    case DateTime.april:
      s += "Apr";
      break;

    case DateTime.may:
      s += "May";
      break;

    case DateTime.june:
      s += "Jun";
      break;

    case DateTime.july:
      s += "Jul";
      break;

    case DateTime.august:
      s += "Aug";
      break;

    case DateTime.september:
      s += "Sept";
      break;
    case DateTime.october:
      s += "Oct";
      break;
    case DateTime.november:
      s += "Nov";
      break;
    case DateTime.december:
      s += "Dec";
      break;
  }

  s += " ${date.year}";
  return s;
}
