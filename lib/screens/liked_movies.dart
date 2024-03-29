// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';
import 'package:upick_test/screens/movie_detail_page.dart';

import 'home_screen.dart';

class LikedMoviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(showBack: false),
      body: Container(
        child: Provider.of<AppData>(context).isSession
            ? LikedMoviesSession(
                userNum: Provider.of<AppData>(context).userNum,
                sessionCode: Provider.of<AppData>(context).sessionCode,
                sessionID: Provider.of<AppData>(context).sessionID,
              )
            : LikedMovies(
                likedMovies: Provider.of<AppData>(context).likedMovies,
              ),
      ),
    );
  }
}

class LikedMoviesSession extends StatefulWidget {
  final int userNum;
  final String sessionCode;
  final String sessionID;

  LikedMoviesSession({this.userNum, this.sessionCode, this.sessionID});

  @override
  _LikedMoviesSessionState createState() => _LikedMoviesSessionState();
}

class _LikedMoviesSessionState extends State<LikedMoviesSession> {
  var firestore = FirebaseFirestore.instance.collection('sessions');

  void reset() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  List everyoneLikedMovies(Map likes, List data) {
    List<Map<dynamic, dynamic>> returnMovies = [];
    Map duplicates = {};
    int numUsers = likes.length;
    likes.forEach((key, value) {
      for (var v in value) {
        // print(v);
        if (!duplicates.containsKey(v)) {
          duplicates[v] = 1;
          // print(duplicates);
        } else if (duplicates.containsKey(v)) {
          duplicates[v] = duplicates[v] + 1;
          // print(duplicates);
        }
      }
    });
    dynamic likedMovies = Map.from(duplicates)
      ..removeWhere((k, v) => v < numUsers);
    likedMovies = likedMovies.keys.toList();
    // print(returnMovies);
    data.forEach((e) {
      // print(e['Title']);
      // print(likedMovies.contains(e['Title']));
      if (likedMovies.contains(e['Title'])) {
        returnMovies.add(e);
      }
    });
    // print(returnMovies);
    return returnMovies;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.doc(widget.sessionID).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // print(snapshot.data.data()['likes']);

        var movies = everyoneLikedMovies(
            snapshot.data.data()['likes'], snapshot.data.data()['data']);

        return Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    'Session ID: ${widget.sessionID.substring(0, 5)}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SelectableText(
                    'People in this session: ${snapshot.data.data()['likes'].length}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      child: Text(
                        'Pick Again',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        reset();
                      },
                    ),
                  ),
                  movies.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "The group didn't like any of these movies :( ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Text(
                          'Here are the movies you all liked',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700),
                        ),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: movies
                        .map<Widget>(
                          (movie) => InkWell(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 1,
                              width: 10,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      movie['Title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Flexible(
                                      child: Hero(
                                          tag: movie['Title'],
                                          child: Image.network(
                                              '${movie['Poster']}')))
                                ],
                              ),
                            ),
                            onTap: () {
                              // launchURL(imdbURL + movie['imdbID']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailPage(movieData: movie),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LikedMovies extends StatefulWidget {
  List<Map> likedMovies = [];
  LikedMovies({this.likedMovies});

  @override
  _LikedMoviesState createState() => _LikedMoviesState();
}

class _LikedMoviesState extends State<LikedMovies> {
  void reset() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: widget.likedMovies.length >= 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          child: Text(
                            'Pick Again',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            reset();
                          },
                        ),
                      ),
                      Text(
                        'Here are the movies you liked',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: widget.likedMovies
                            .map<Widget>(
                              (movie) => InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  height: 1,
                                  width: 10,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          movie['Title'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Flexible(
                                          child: Hero(
                                        tag: movie['Title'],
                                        child:
                                            Image.network('${movie['Poster']}'),
                                      ))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // launchURL(imdbURL + movie['imdbID']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailPage(movieData: movie),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                            child: Text(
                              'Pick Again',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              reset();
                            },
                          ),
                        ),
                        Text(
                          "You didn't like any of these movies :(",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700),
                        )
                      ]),
          ),
        ),
      ),
    );
  }
}
