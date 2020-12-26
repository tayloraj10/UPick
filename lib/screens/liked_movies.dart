import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LikedMovies extends StatefulWidget {
  List<Map> likedMovies = [];
  LikedMovies({this.likedMovies});

  @override
  _LikedMoviesState createState() => _LikedMoviesState();
}

class _LikedMoviesState extends State<LikedMovies> {
  void reset() {
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: UPickAppBar(showBack: false),
        body: Container(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: widget.likedMovies.length >= 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: RaisedButton(
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Text(
                                                movie['Title'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'NunitoSans',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Flexible(
                                                child: Image.network(
                                                    '${movie['Poster']}'))
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        launchURL(imdbURL + movie['imdbID']);
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
                                child: RaisedButton(
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
          ),
        ),
      ),
    );
  }
}
