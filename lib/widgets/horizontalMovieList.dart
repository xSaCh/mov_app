import 'package:flutter/material.dart';
import 'package:linux_test/movie_detail_page.dart';
import 'package:linux_test/tv_detail_page.dart';
import 'package:linux_test/utils/api.dart';
import 'package:linux_test/models/common.dart';
import 'package:linux_test/models/film.dart';
import 'package:linux_test/widgets/dataCard.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<ResultFilm> imageData;
  final double height;
  final double width;
  const HorizontalMovieList(
      {super.key,
      required this.imageData,
      this.height = 250,
      this.width = 175});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          itemCount: imageData.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: () {
                    debugPrint(
                        "${imageData[index].id}\t:${imageData[index].title}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            imageData[index].type == MediaType.movie
                                ? MovieDetailPage(
                                    movieID: imageData[index].id.toString())
                                : TvDetailPage(
                                    movieID: imageData[index].id.toString())));
                  },
                  onLongPress: () {
                    debugPrint("DATA: ${imageData[index].id}");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DataCard(imageData[index]);
                        });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                          width: width,
                          child: imageData[index].posterPath != null
                              ? Image.network(
                                  MovieApi.getImageLink(
                                      imageData[index].posterPath!,
                                      width: ImageWidth.w185),
                                  fit: BoxFit.cover)
                              : Container(
                                  height: height,
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.hide_image_outlined,
                                      size: 50))),
                    ),
                    Positioned(
                        bottom: 10,
                        left: 10,
                        child: CircularProgressIndicator(
                          value: imageData[index].voteAverage / 10.0,
                          strokeWidth: 6,
                        )),
                    Positioned(
                        bottom: 19,
                        left: 17,
                        child: Text(
                            imageData[index].voteAverage.toStringAsFixed(1)))
                  ])),
            );
          }),
    );
  }
}
