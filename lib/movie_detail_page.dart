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

  Future getMovieDetail() async {
    var data = await MovieApi.getMovie(widget.movieID);
    setState(() {
      movieData = data;
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
    super.initState();
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
      body: Stack(children: [
        Image.network(
            MovieApi.getImageLink(movieData["backdrop_path"],
                width: ImageWidth.w500),
            width: MediaQuery.of(context).size.width,
            height: 211,
            fit: BoxFit.cover),
        SingleChildScrollView(
          child: SafeArea(
              child: Column(
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey)),
                    ],
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                child: Text("Fight what's within.",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    "${movieData["overview"] ?? "Not Found"}",
                  )),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 0, 6),
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
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 0, 6),
                child: Text("Fetured Cast", style: TextStyle(fontSize: 18)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                height: 50,
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
            ],
          )),
        )
      ]),
    );
  }
}
