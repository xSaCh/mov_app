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
  var showData = [];
  int trendPage = 1;

  Future<void> getMoreData() async {
    var d = await MovieApi.getTrendMovies(page: trendPage);
    setState(() {
      showData.addAll(d);
      trendPage++;
    });
  }

  Future initSearch() async {
    var data = await MovieApi.getTrendMovies();
    setState(() {
      showData = data;
      trendPage++;
    });
  }

  ScrollController c = ScrollController();
  @override
  void initState() {
    initSearch();

    c.addListener(() {
      if (c.position.maxScrollExtent == c.offset) {
        getMoreData();
      }
    });
    super.initState();
  }

  Widget searchListWidget() {
    if (showData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          key: const PageStorageKey("searchListStorage"),
          itemCount: showData.length + 1,
          controller: c,
          itemBuilder: (context, index) {
            if (index < showData.length) {
              debugPrint("${showData.length} $index");
              return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                  child: SearchMovieCard(searchData: showData[index]));
            } else {
              debugPrint("END");
              return const Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Hello",
              hintText: "HINT",
            ),
            onSubmitted: (String txt) async {
              await MovieApi.searchMovies(txt);
            }),
        const SizedBox(height: 10),
        Expanded(child: searchListWidget())
      ]),
    );
  }
}
