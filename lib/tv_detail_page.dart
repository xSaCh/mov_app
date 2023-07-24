import 'package:flutter/material.dart';
import "models/common.dart";
import 'models/film.dart';
import "utils/api.dart";

class TvDetailPage extends StatefulWidget {
  final String movieID;
  const TvDetailPage({super.key, required this.movieID});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  // Future<Movie> movieData;
  List<Map> tvImgData = [];
  List<Map> tvVidData = [];
  List<Map> tvCastData = [];
  List<ResultFilm> recommendedTv = [];

  Future<Tv> getTvDetail() async {
    var data = await MovieApi.getTv(widget.movieID);
    return Tv.fromJson(data);
  }

  Future getRecommendedTv() async {
    var data = await MovieApi.getTrendTV();
    setState(() {
      recommendedTv = data.map((e) => ResultFilm.fromJson(e)).toList();
    });
  }

  Future getImages() async {
    var data = await MovieApi.getTvImages(widget.movieID);
    List<Map> listData = [];
    listData.addAll(List<Map>.from(data["posters"]!));
    listData.addAll(List<Map>.from(data["backdrops"]!));
    setState(() {
      tvImgData = listData;
    });
  }

  Future getVideos() async {
    var data = await MovieApi.getTvVideos(widget.movieID);

    List<Map> listData = [];
    for (var k in data.keys) {
      listData.addAll(List<Map>.from(data[k]!));
    }
    setState(() {
      tvVidData = listData;
    });
  }

  Future getCast() async {
    var data = await MovieApi.getTvCast(widget.movieID);

    List<Map> listData = [];

    listData.addAll(List<Map>.from(data["cast"]!));
    listData.addAll(List<Map>.from(data["crew"]!));
    setState(() {
      tvCastData = listData;
    });
  }

  String getFormatedRelDate(DateTime date) {
    String s = "";
    switch (date.month) {
      case DateTime.january:
        s += "January";
        break;
      case DateTime.february:
        s += "February";
        break;

      case DateTime.march:
        s += "March";
        break;

      case DateTime.april:
        s += "April";
        break;

      case DateTime.may:
        s += "May";
        break;

      case DateTime.june:
        s += "June";
        break;

      case DateTime.july:
        s += "July";
        break;

      case DateTime.august:
        s += "August";
        break;

      case DateTime.september:
        s += "September";
        break;
      case DateTime.october:
        s += "October";
        break;
      case DateTime.november:
        s += "November";
        break;
      case DateTime.december:
        s += "December";
        break;
    }

    s += " ${date.year}";
    return s;
  }

  @override
  void initState() {
    getTvDetail();
    getCast();
    getImages();
    getVideos();
    getRecommendedTv();
    super.initState();
  }

  Widget tvInfoView(String title, String value) {
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

  Widget displayWidget(BuildContext context, Tv tvData) {
    // String runtime =
    //     "${tvData.firstAirDate ~/ 60}hr ${tvData.runtime % 60}min";

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: [
            // Background Image
            tvData.backdropPath != ""
                ? Image.network(
                    MovieApi.getImageLink(tvData.backdropPath,
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
                  // crossAxisAlignment: CrossAxisAlignment.,
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
                        child: tvData.posterPath != ""
                            ? Image.network(
                                MovieApi.getImageLink(tvData.posterPath,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 75),
                        Text(tvData.title,
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(
                            "${tvData.firstAirDate!.year}  :  ${tvData.status.name}",
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
                      tvData.summary ?? "Not Found",
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
                    itemCount: tvData.genres.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                            onPressed: () {},
                            child: Text(tvData.genres[index].name)),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Fetured Cast
                clickableTitle(
                    "Fetured Cast", () => debugPrint("${tvData.id}")),
                //TODO: Add Fetured Cast Page
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tvCastData.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("${movieCastData[index]['name']}"),
                              Text("${tvCastData[index]['name']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),

                              Text(
                                  "${tvCastData[index]['known_for_department']}",
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
                tvInfoView("Original Title", tvData.originalTitle),
                tvInfoView("Status", tvData.status.name),
                tvInfoView(
                    "First Air Date", getFormatedRelDate(tvData.firstAirDate!)),
                tvInfoView(
                    "Last Air Date", getFormatedRelDate(tvData.lastAirDate!)),
                //TODO: Add api to get movie age rating

                // tvInfoView("Budget", "${tvData.}"),
                // tvInfoView("Revenue", "${tvData.revenue}"),
                // tvInfoView("Original language", tvData.),
                //#endregion

                //#region Trailer
                clickableTitle("Trailer", () => debugPrint("${tvData.id}")),
                //TODO: Add Trailer Page
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tvVidData.length,
                    primary: false,
                    itemBuilder: ((context, index) {
                      //TODO: Play Video Link on click
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => debugPrint("${tvImgData[index]}"),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox(
                                child: Image.network(
                                    MovieApi.getVideoThumbailLink(
                                        tvVidData[index]),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                //#endregion

                //#region Media
                clickableTitle("Media", () => debugPrint("${tvData.id}")),
                //TODO: Add Media Movie Page

                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tvImgData.length,
                    primary: false,
                    // shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        //TODO: show fullScreen on click
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => debugPrint("${tvImgData[index]}"),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox(
                                child: Image.network(
                                    MovieApi.getImageLink(
                                        tvImgData[index]["file_path"],
                                        width:
                                            tvImgData[index]['aspect_ratio'] < 1
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
                    "Recommended Movie", () => debugPrint("${tvData.id}")),
                //TODO: Add Recommended Movie Page
                SizedBox(
                    height: 170,
                    child: recommendedTv.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedTv.length,
                            primary: false,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => TvDetailPage(
                                                movieID: recommendedTv[index]
                                                    .id
                                                    .toString())));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SizedBox(
                                        child: Image.network(
                                            MovieApi.getImageLink(
                                                recommendedTv[index]
                                                    .posterPath!,
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
      future: getTvDetail(),
    );
  }
}
