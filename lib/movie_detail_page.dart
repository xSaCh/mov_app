import 'package:flutter/material.dart';
import "utils/api.dart";

class MovieDetailPage extends StatefulWidget {
  final String movieID;
  const MovieDetailPage({super.key, required this.movieID});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map movieData = {};
  List recommendedMovies = [];

  Future getMovieDetail() async {
    var data = await MovieApi.getMovie(widget.movieID);
    setState(() {
      movieData = data;
    });
  }

  Future getRecommendedMovies() async {
    var data = await MovieApi.getPopularMovies();
    setState(() {
      recommendedMovies = data;
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
    getRecommendedMovies();
    super.initState();
  }

  Padding movieInfoView(String title, String value) {
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

  @override
  Widget build(BuildContext context) {
    if (movieData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    List genreList = ["Action", "Animation", "adventure", "shounen Anime"];
    DateTime relDate = DateTime.parse(movieData["release_date"]);
    String runtime =
        "${movieData["runtime"] ~/ 60}hr ${movieData["runtime"] % 60}min";

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: [
            Image.network(
                MovieApi.getImageLink(movieData["backdrop_path"],
                    width: ImageWidth.original),
                width: MediaQuery.of(context).size.width,
                height: 211,
                fit: BoxFit.cover),
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
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
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
                        child: Image.network(
                            MovieApi.getImageLink(movieData["poster_path"],
                                width: ImageWidth.w342),
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 75),
                        Text(movieData["title"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("${getFormatedRelDate(relDate)}  :  $runtime",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.grey)),
                      ],
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
                      "${movieData["overview"] ?? "Not Found"}",
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
                    itemCount: movieData["genres"].length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                            onPressed: () {},
                            child: Text(movieData["genres"][index]["name"])),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Fetured Cast
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 0, 6),
                  child: Text("Fetured Cast", style: TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: genreList.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Salman Khan"),
                              Text(
                                "Lead Actor",
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ));
                    }),
                  ),
                ),
                //#endregion

                //#region Movie Info
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
                  child: Text("Movie Info",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                movieInfoView(
                    "Original Title", "${movieData["original_title"]}"),
                movieInfoView("Status", "${movieData["status"]}"),
                movieInfoView("Runtime", runtime),
                //TODO: Add api to get movie age rating
                movieInfoView("Budget", "${movieData["budget"]}"),
                movieInfoView("Revenue", "${movieData["revenue"]}"),
                movieInfoView(
                    "Original language", "${movieData["original_language"]}"),
                //#endregion

                //#region Trailer
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
                  child: Text("Trailer", style: TextStyle(fontSize: 18)),
                ),
                //TODO: Get All Video Links
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox(
                              child: Image.network(
                                  MovieApi.getImageLink(
                                      movieData['backdrop_path'],
                                      width: ImageWidth.w500),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Media
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
                  child: Text("Media", style: TextStyle(fontSize: 18)),
                ),
                //TODO: Get all media links
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox(
                              child: Image.network(
                                  MovieApi.getImageLink(
                                      index % 2 == 0
                                          ? movieData['poster_path']
                                          : movieData['backdrop_path'],
                                      width: index % 2 == 0
                                          ? ImageWidth.w154
                                          : ImageWidth.w500),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Recommended Movies
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
                  child: Text("Recommended Movies",
                      style: TextStyle(fontSize: 18)),
                ),
                //TODO: Get all media links
                SizedBox(
                    height: 130,
                    child: recommendedMovies.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedMovies.length,
                            primary: false,
                            // shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
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
}
