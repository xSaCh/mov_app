// ignore: file_names
import 'package:flutter/material.dart';
import '../utils/api.dart';

class SearchMovieCard extends StatelessWidget {
  final Map searchData;
  const SearchMovieCard({super.key, required this.searchData});

  @override
  Widget build(BuildContext context) {
    String genres = "";
    for (var i = 0; i < searchData["genre_ids"].length; i++) {
      genres += "${searchData["genre_ids"][i]} ,";
    }

    return Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
                width: 80,
                child: Image.network(MovieApi.getImageLink(
                    searchData["poster_path"],
                    width: ImageWidth.w92))),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${searchData["title"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "${searchData["media_type"]} ${searchData["release_date"]}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text("🌟️ ${searchData["vote_average"]}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey))),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text("Genre: $genres",
                        // "Genre: Action, Adventure, Comedy, Animation, Helo",
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  )
                ],
              ),
            ),
          )
        ]);
  }
}
