import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'utils/api.dart';
import 'widgets/searchMovieCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // String searchUrl =
  //     "https://api.themoviedb.org/3/search/movie?api_key=a3ca43df787ec6b692b7e1e2d53a65ec&query=";
  // String imageUrl = "https://image.tmdb.org/t/p/original";

  // Future<List<dynamic>> searchMovies(String query) async {
  //   final resp = await http.get(Uri.parse(searchUrl + query));
  //   debugPrint(resp.body);
  //   return jsonDecode(resp.body);
  // }

  // Future<List<dynamic>> getTrendMovies() async {
  //   String trendUrl =
  //       "https://api.themoviedb.org/3/trending/movie/week?api_key=a3ca43df787ec6b692b7e1e2d53a65ec";
  //   final resp = await http.get(Uri.parse(trendUrl));
  //   debugPrint(resp.body);
  //   return jsonDecode(resp.body)["results"];
  // }

  // List<dynamic> trendMovies = [];

  // @override
  // void initState() async {
  //   trendMovies = await getTrendMovies();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Hello",
                hintText: "HINT",
              ),
              onSubmitted: (String txt) async {
                await MovieApi.searchMovies(txt);
              }),
          // ListView.builder(itemCount: trendMovies.length,itemBuilder: (BuildContext context, int index) {})
          const SizedBox(height: 10),
          FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text("[ERROR] ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data as List<dynamic>;

                    return ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                              child: SearchMovieCard(searchData: data[index]));
                        });
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
              future: MovieApi.getTrendMovies())
        ]),
      ),
    );
  }
}
