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
  List<Map> movieImgData = [];
  List<Map> movieVidData = [];
  List<Map> movieCastData = [];
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

  @override
  Widget build(BuildContext context) {
    if (movieData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
                clickableTitle(
                    "Fetured Cast", () => debugPrint("${movieData['id']}")),
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
                clickableTitle(
                    "Trailer", () => debugPrint("${movieData['id']}")),
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
                clickableTitle("Media", () => debugPrint("${movieData['id']}")),
                //TODO: Add Media Movie Page

                SizedBox(
                  height: 130,
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
                clickableTitle("Recommended Movie",
                    () => debugPrint("${movieData['id']}")),
                //TODO: Add Recommended Movie Page
                SizedBox(
                    height: 140,
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
}
