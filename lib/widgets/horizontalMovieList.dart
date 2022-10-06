import 'package:flutter/material.dart';
import '../movie_detail_page.dart';
import '../utils/api.dart';

class HorizontalMovieList extends StatelessWidget {
  final List imageData;
  final double height;
  final double width;
  const HorizontalMovieList(
      {super.key,
      required this.imageData,
      this.height = 250,
      this.width = 175});

  @override
  Widget build(BuildContext context) {
    double b = 10;
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
                        "${imageData[index]}\n${imageData[index]['release_date'].runtimeType}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                            movieID: imageData[index]["id"].toString())));
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                          width: width,
                          child: Image.network(
                              MovieApi.getImageLink(
                                  imageData[index]['poster_path'],
                                  width: ImageWidth.w185),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                        bottom: 10,
                        left: 10,
                        child: CircularProgressIndicator(
                          value: imageData[index]['vote_average'] / 10.0,
                          strokeWidth: 6,
                        )),
                    Positioned(
                        bottom: 19,
                        left: 17,
                        child: Text(imageData[index]['vote_average']
                            .toStringAsFixed(1)))
                  ])),
            );
          }),
    );
  }
}
