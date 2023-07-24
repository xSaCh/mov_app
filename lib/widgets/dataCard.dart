import 'package:flutter/material.dart';
import 'package:linux_test/models/film.dart';
import 'package:linux_test/utils/user.dart';
import 'package:linux_test/global.dart' as global;

class DataCard extends StatefulWidget {
  final ResultFilm film;

  const DataCard(this.film, {super.key});

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {
    bool onWatchlist = global.globalUser.watchList.containsKey(widget.film);
    bool onWatched = global.globalUser.watched.containsKey(widget.film);

    debugPrint("Listeners: ${global.userChange.hasListeners}");
    return AlertDialog(
      title: const Text("Pop up"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
              onPressed: () {
                setState(() {
                  if (onWatchlist) {
                    bool _ =
                        global.globalUser.removeMovieFromWatchlist(widget.film);
                    debugPrint("removed from watchlist ${widget.film.id} $_");
                  } else {
                    bool _ = global.globalUser.addMovieToWatchlist(widget.film);
                    debugPrint("added to watchlist ${widget.film.id} $_");
                  }
                  global.userChange.value = !global.userChange.value;
                  Navigator.of(context).pop();
                });
              },
              icon: onWatchlist
                  ? const Icon(Icons.remove_circle_outline_rounded)
                  : const Icon(Icons.add_box_outlined),
              label: Text(
                onWatchlist ? "remove from watchlist" : "add To watchlist",
                style: TextStyle(
                    color: onWatchlist ? Colors.greenAccent : Colors.blueGrey),
              )),
          TextButton.icon(
              onPressed: () {
                setState(() {
                  if (onWatched) {
                    bool _ =
                        global.globalUser.removeMovieFromWatched(widget.film);
                    debugPrint("removed from watched ${widget.film.id} $_");
                  } else {
                    bool _ = global.globalUser.addMovieToWatched(widget.film);
                    debugPrint("added to watched ${widget.film.id} $_");
                  }
                  global.userChange.value = !global.userChange.value;
                  Navigator.of(context).pop();
                });
              },
              icon: onWatched
                  ? const Icon(Icons.remove_circle_outline_rounded)
                  : const Icon(Icons.add_box_outlined),
              label: Text(
                onWatched ? "remove from watched" : "Add To watched",
                style: TextStyle(
                    color: onWatched ? Colors.greenAccent : Colors.blueGrey),
              ))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
