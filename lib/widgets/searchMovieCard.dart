// ignore: file_names
import 'package:flutter/material.dart';
import 'package:linux_test/models/film.dart';
import '../utils/api.dart';
import 'package:linux_test/models/common.dart';

class SearchMovieCard extends StatelessWidget {
  final ResultFilm searchData;
  const SearchMovieCard({super.key, required this.searchData});

  @override
  Widget build(BuildContext context) {
    String genres = "";
    for (var i = 0; i < searchData.genres.length; i++) {
      genres += "${searchData.genres[i].name} ,";
    }

    return Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
                width: 80,
                child: searchData.posterPath != null
                    ? Image.network(MovieApi.getImageLink(
                        searchData.posterPath!,
                        width: ImageWidth.w92))
                    : Container(
                        height: 120,
                        color: Colors.grey.shade800,
                        child:
                            const Icon(Icons.hide_image_outlined, size: 50))),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${searchData.title}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "${searchData.type.name} ${searchData.releaseDate?.year}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text("🌟️ ${searchData.voteAverage}",
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
