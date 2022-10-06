import 'package:flutter/material.dart';
import 'search_page.dart';
import 'widgets/horizontalMovieList.dart';
import 'utils/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var trendMovies = [];
  Map<Genre, List> genreMoviesDatas = {};
  Map<String, List> movieDatas = {};

  Future getGenreMovie(Genre genre) async {
    var data = await MovieApi.getRecentMoviesByGenre(genre);
    setState(() {
      genreMoviesDatas[genre] = data;
    });
  }

  Future getTrendMov() async {
    var data = await MovieApi.getTrendMovies();
    setState(() {
      movieDatas["Trending Movies"] = data;
    });
  }

  Future getTrendTv() async {
    var data = await MovieApi.getTrendTV();
    setState(() {
      movieDatas["Trending Shows"] = data;
    });
  }

  Future getPopMov() async {
    var data = await MovieApi.getPopularMovies();
    setState(() {
      movieDatas["Popular Movies"] = data;
    });
  }

  Future getPopTv() async {
    var data = await MovieApi.getPopularTV();
    setState(() {
      movieDatas["Popular Shows"] = data;
    });
  }

  @override
  void initState() {
    genreMoviesDatas[Genre.Action] = [];
    genreMoviesDatas[Genre.Drama] = [];
    genreMoviesDatas[Genre.Romance] = [];
    genreMoviesDatas[Genre.Adventure] = [];
    genreMoviesDatas[Genre.Science_Fiction] = [];

    getTrendMov();
    getTrendTv();
    getPopMov();
    getPopTv();

    getGenreMovie(Genre.Action);
    getGenreMovie(Genre.Drama);
    getGenreMovie(Genre.Romance);
    getGenreMovie(Genre.Adventure);
    getGenreMovie(Genre.Science_Fiction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardsList = [];

    for (String title in movieDatas.keys) {
      //Trending Movies
      cardsList.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          )));
      cardsList.add(movieDatas[title]!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : HorizontalMovieList(imageData: movieDatas[title]!));
    }

    for (Genre genre in genreMoviesDatas.keys) {
      // Title
      cardsList.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            genre.name,
            style: const TextStyle(fontSize: 20),
          )));
      // Image List
      cardsList.add(genreMoviesDatas[genre]!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : HorizontalMovieList(imageData: genreMoviesDatas[genre]!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("MovieDB"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const SearchPage();
                }));
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cardsList,
      )),
    );
  }
}
