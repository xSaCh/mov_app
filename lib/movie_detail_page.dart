import 'package:flutter/material.dart';
import "models/common.dart";
import 'models/film.dart';
import "utils/api.dart";

class MovieDetailPage extends StatefulWidget {
  final String movieID;
  const MovieDetailPage({super.key, required this.movieID});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  // Future<Movie> movieData;
  List<Map> movieImgData = [];
  List<Map> movieVidData = [];
  List<Map> movieCastData = [];
  List recommendedMovies = [];

  Future<Movie> getMovieDetail() async {
    var data = await MovieApi.getMovie(widget.movieID);
    // setState(() {
    //   movieData = Movie.fromJson(data);
    // });
    return Movie.fromJson(data);
  }

  Future getRecommendedMovies() async {
    var data = await MovieApi.getPopularMovies();
    setState(() {
      recommendedMovies = data;
    });
  }

  Future getImages() async {
    var data = await MovieApi.getMovieImages(widget.movieID);
    List<Map> listData = [];
    listData.addAll(List<Map>.from(data["posters"]!));
    listData.addAll(List<Map>.from(data["backdrops"]!));
    setState(() {
      movieImgData = listData;
    });
  }

  Future getVideos() async {
    var data = await MovieApi.getMovieVideos(widget.movieID);

    List<Map> listData = [];
    for (var k in data.keys) {
      listData.addAll(List<Map>.from(data[k]!));
    }
    setState(() {
      movieVidData = listData;
    });
  }

  Future getCast() async {
    var data = await MovieApi.getMovieCast(widget.movieID);

    List<Map> listData = [];

    listData.addAll(List<Map>.from(data["cast"]!));
    listData.addAll(List<Map>.from(data["crew"]!));
    setState(() {
      movieCastData = listData;
    });
  }

  String getFormatedRelDate(DateTime date) {
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

  @override
  void initState() {
    getMovieDetail();
    getCast();
    getImages();
    getVideos();
    getRecommendedMovies();
    super.initState();
  }

  Widget movieInfoView(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
      child: Row(children: [
        SizedBox(
            width: 135,
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500))),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(value,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ]),
    );
  }

  Widget clickableTitle(String title, void Function()? tapFunc) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
          onTap: tapFunc,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward),
                  )
                ]),
          )),
    );
  }

  Widget displayWidget(BuildContext context, Movie movieData) {
    String runtime =
        "${movieData.runtime ~/ 60}hr ${movieData.runtime % 60}min";

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: [
            // Background Image
            movieData.backdropPath != ""
                ? Image.network(
                    MovieApi.getImageLink(movieData.backdropPath,
                        width: ImageWidth.w500),
                    width: MediaQuery.of(context).size.width,
                    height: 211,
                    fit: BoxFit.cover)
                : Container(
                    height: 211,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade800),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 34,
                      )),
                ),
                const SizedBox(height: 60),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Poster Image
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 30)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: movieData.posterPath != ""
                            ? Image.network(
                                MovieApi.getImageLink(movieData.posterPath,
                                    width: ImageWidth.w342),
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover)
                            : Container(
                                height: 150,
                                width: 100,
                                color: Colors.grey.shade800,
                                child: const Icon(Icons.hide_image_outlined,
                                    size: 50)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 55),

                          Text(movieData.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(
                              "${getFormatedRelDate(movieData.releaseDate!)}  :  $runtime",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey)),
                          // const SizedBox(height: 15),
                        ],
                      ),
                    )
                  ],
                ),

                //#region Summary
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                  child: Text("Fight what's within.",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      movieData.summary ?? "Not Found",
                    )),
                //#endregion

                //#region Genre
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 6),
                  child: Text("Genre", style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieData.genres.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                            onPressed: () {},
                            child: Text(movieData.genres[index].name)),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Fetured Cast
                clickableTitle(
                    "Fetured Cast", () => debugPrint("${movieData.id}")),
                //TODO: Add Fetured Cast Page
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieCastData.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("${movieCastData[index]['name']}"),
                              Text("${movieCastData[index]['name']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),

                              Text(
                                  "${movieCastData[index]['known_for_department']}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey))
                            ],
                          ));
                    }),
                  ),
                ),
                //#endregion

                //#region Movie Info
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 6),
                  child: Text("Movie Info",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                movieInfoView("Original Title", movieData.originalTitle),
                movieInfoView("Status", movieData.status.name),
                movieInfoView("Runtime", runtime),
                //TODO: Add api to get movie age rating
                movieInfoView("Budget", "${movieData.budget}"),
                movieInfoView("Revenue", "${movieData.revenue}"),
                movieInfoView("Original language", movieData.originalLanguage),
                //#endregion

                //#region Trailer
                clickableTitle("Trailer", () => debugPrint("${movieData.id}")),
                //TODO: Add Trailer Page
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieVidData.length,
                    primary: false,
                    itemBuilder: ((context, index) {
                      //TODO: Play Video Link on click
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => debugPrint("${movieImgData[index]}"),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox(
                                child: Image.network(
                                    MovieApi.getVideoThumbailLink(
                                        movieVidData[index]),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Media
                clickableTitle("Media", () => debugPrint("${movieData.id}")),
                //TODO: Add Media Movie Page

                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieImgData.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        //TODO: show fullScreen on click
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => debugPrint("${movieImgData[index]}"),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox(
                                child: Image.network(
                                    MovieApi.getImageLink(
                                        movieImgData[index]["file_path"],
                                        width: movieImgData[index]
                                                    ['aspect_ratio'] <
                                                1
                                            ? ImageWidth.w154
                                            : ImageWidth.w342),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Recommended Movies
                clickableTitle(
                    "Recommended Movie", () => debugPrint("${movieData.id}")),
                //TODO: Add Recommended Movie Page
                SizedBox(
                    height: 170,
                    child: recommendedMovies.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedMovies.length,
                            primary: false,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailPage(
                                                    movieID:
                                                        recommendedMovies[index]
                                                                ["id"]
                                                            .toString())));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SizedBox(
                                        child: Image.network(
                                            MovieApi.getImageLink(
                                                recommendedMovies[index]
                                                    ["poster_path"],
                                                width: ImageWidth.w154),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              );
                            }),
                          )
                        : const CircularProgressIndicator()),
                //#endregion
              ],
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return const Center(child: Text("Error"));
        }
        return displayWidget(context, snapshot.data!);
      },
      future: getMovieDetail(),
    );
  }
}
