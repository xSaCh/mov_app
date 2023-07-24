import 'package:flutter/material.dart';
import 'package:linux_test/models/film.dart';
import 'package:linux_test/widgets/dataCard.dart';
import 'utils/api.dart';
import 'widgets/searchMovieCard.dart';
import 'movie_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var showData = [];
  List<ResultFilm> showDataM = [];
  int trendPage = 1;

  Future<void> getMoreData() async {
    var d = await MovieApi.getTrendMovies(page: trendPage);
    setState(() {
      showData.addAll(d);
      showDataM.addAll(d.map((e) => ResultFilm.fromJson(e)));
      trendPage++;
    });
  }

  Future initSearch() async {
    var data = await MovieApi.getTrendMovies();
    setState(() {
      showData = data;
      showDataM = data.map((e) => ResultFilm.fromJson(e)).toList();
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
    if (showDataM.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          key: const PageStorageKey("searchListStorage"),
          itemCount: showDataM.length + 1,
          controller: c,
          itemBuilder: (context, index) {
            if (index < showDataM.length) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => MovieDetailPage(
                              movieID: showDataM[index].id.toString()))));
                    },
                    onLongPress: () {
                      debugPrint("DATA: ${showDataM[index].id}");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DataCard(showDataM[index]);
                          });
                    },
                    child: SearchMovieCard(searchData: showDataM[index])),
              );
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
            labelText: "Search Movie",
            hintText: "Enter name to search movie",
          ),
          onChanged: (String txt) async {
            var data = await MovieApi.search(txt);
            setState(() {
              showData = data;
              showDataM = data.map((e) => ResultFilm.fromJson(e)).toList();

              if (data.isNotEmpty) {
                debugPrint(txt);
              }
            });
          },
        ),
        const SizedBox(height: 10),
        Expanded(child: searchListWidget())
      ]),
    );
  }
}
