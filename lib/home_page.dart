import 'package:flutter/material.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int radioValue = 0;
  Widget radioButton(String text, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: radioValue == index ? Colors.blueAccent : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: TextButton(
          onPressed: () {
            setState(() {
              radioValue = index;
            });
          },
          child: Text(text, style: const TextStyle(color: Colors.white))),
    );
  }

  @override
  Widget build(BuildContext context) {
    int i = -1;
    imageCache.clear();
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
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Text(
                "Action",
                style: TextStyle(fontSize: 20),
              )),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                        onTap: () => debugPrint("Tap"),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              width: 125,
                              child: i != 1
                                  ? Image.asset("images/${index % 10}.jpg",
                                      fit: BoxFit.fitHeight)
                                  : Image.network(
                                      "https://cdn.pixabay.com/photo/2017/08/30/01/05/milky-way-2695569__340.jpg")),
                        )),
                  );
                }),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Text(
                "Drama",
                style: TextStyle(fontSize: 20),
              )),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (BuildContext context, int index) {
                  debugPrint("images/wall.jpg");
                  i++;
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () => debugPrint("Tap"),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              width: 125,
                              child: Image.asset("images/${i % 10}.jpg",
                                  fit: BoxFit.cover))),
                    ),
                  );
                }),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Text(
                "Adventure",
                style: TextStyle(fontSize: 20),
              )),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (BuildContext context, int index) {
                  debugPrint("images/wall.jpg");
                  i++;

                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () => debugPrint("Tap"),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              width: 125,
                              child: Image.asset("images/${i % 10}.jpg",
                                  fit: BoxFit.cover))),
                    ),
                  );
                }),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Text(
                "Science Friction",
                style: TextStyle(fontSize: 20),
              )),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (BuildContext context, int index) {
                  debugPrint("images/wall.jpg");
                  i++;
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () => debugPrint("Tap"),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              width: 125,
                              child: Image.asset("images/${i % 10}.jpg",
                                  fit: BoxFit.cover))),
                    ),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
