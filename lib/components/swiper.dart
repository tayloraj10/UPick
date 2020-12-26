import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:upick_test/constants.dart';
import 'package:upick_test/sample_data.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/screens/movie_detail_page.dart';
import 'package:upick_test/utilities/fetch_url.dart';
import 'package:sampling/sampling.dart';
import 'dart:math';

class Swiper extends StatefulWidget {
  List<Map<dynamic, dynamic>> movieData;

  Swiper({@required this.movieData});

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with TickerProviderStateMixin {
  Color backgroundColor = appBackgroundColor;
  FetchURL fetcher = FetchURL();
  bool isLoading = true;
  bool swipingFinished = false;

  int movieIndex = 0;
  List<String> movies = [];
  // List<String> movies = [
  //   'Avengers',
  //   'Baby Driver',
  //   'Once Upon a Time... In Hollywood',
  //   'Pulp Fiction',
  //   'Napoleon Dynamite'
  // ];
  List movieData = []; //sampleData;
  List<Map> likedMovies = [];

  List getRandomMovies(int n) {
    dynamic sampler = new ReservoirSampler(n, random: new Random.secure());
    sampler.addAll(widget.movieData);
    return sampler.getSample();
  }

  void setMovieData() {
    setState(() {
      movieData = getRandomMovies(10);
      // movieData = widget.movieData;
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchMovieData();
    setMovieData();
    setState(() {
      print('FINISHED LOADING');
      isLoading = false;
    });
  }

  Future<void> fetchMovies() async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$movie_db_api_key&language=en-US';
    print(url);
    var data = await fetcher.getData(url);
    // print(data);
    // for (var movie in data['results']) {
    //   movies.add(movie['title']);
    // }
    // print(movies);
  }

  // void fetchMovieData() async {
  //   await fetchMovies();
  //   print(movies.sublist(0, 10));
  //   for (String movie in movies.sublist(0, 10)) {
  //     var data = await fetcher.getData(urlStub + movie);
  //     movieData.add(data);
  //     // print(data);
  //   }
  //   setState(() {
  //     print('FINISHED LOADING');
  //     isLoading = false;
  //   });
  // }

  void nextMovie() {
    if (movieIndex == movieData.length - 1) {
      setState(() {
        swipingFinished = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LikedMovies(
            likedMovies: likedMovies,
          ),
        ),
      );
    } else {
      setState(() {
        movieIndex++;
      });
      // print(movieData[movieIndex]);
    }
  }

  void likedMovie() {
    setState(() {
      // print(movieData[movieIndex]);
      likedMovies.add(movieData[movieIndex]);
    });
  }

  void resetBackgroundColor() {
    setState(() {
      backgroundColor = appBackgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: isLoading == true
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
                height: 50,
                width: 50,
              ),
            )
          : Scrollbar(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                          movieData[movieIndex]['Title'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.lightBlueAccent,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          launchURL(imdbURL + movieData[movieIndex]['imdbID']);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text.rich(
                          TextSpan(
                            text: (movieData[movieIndex]['Plot'] ?? '') == 'N/A'
                                ? 'No plot available'
                                : movieData[movieIndex]['Plot'] ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700),
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                  movieData: movieData[movieIndex]),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: TinderSwapCard(
                            orientation: AmassOrientation.BOTTOM,
                            totalNum: movieData.length,
                            stackNum: 2,
                            swipeEdge: 4.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                            maxHeight: MediaQuery.of(context).size.width * 0.9,
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            minHeight: MediaQuery.of(context).size.width * 0.8,
                            cardBuilder: (context, index) {
                              // print('index ${index}');
                              return Card(
                                child: Hero(
                                  child: Image.network(
                                      '${movieData[index]['Poster']}' == 'N/A'
                                          ? noPosterUrl
                                          : '${movieData[index]['Poster']}'),
                                  tag: movieData[index]['Title'],
                                ),
                              );
                            },
                            cardController: controller = CardController(),
                            swipeUpdateCallback:
                                (DragUpdateDetails details, Alignment align) {
                              /// Get swiping card's alignment
                              print(align);
                              if (align.x < -1) {
                                // print("Card is LEFT swiping");
                                setState(() {
                                  backgroundColor = Colors.redAccent;
                                });
                              } else if (align.x > 1) {
                                // print("Card is RIGHT swiping");
                                setState(() {
                                  backgroundColor = Colors.lightGreenAccent;
                                });
                              } else {
                                resetBackgroundColor();
                              }
                            },
                            swipeCompleteCallback:
                                (CardSwipeOrientation orientation, int index) {
                              // print(orientation.toString());
                              if (orientation == CardSwipeOrientation.RECOVER) {
                                print("Card Recovered");
                                print(movieData.length);
                                resetBackgroundColor();
                              } else if (orientation ==
                                  CardSwipeOrientation.LEFT) {
                                print("Card is LEFT swiping");
                                print(movieData.length);
                                resetBackgroundColor();
                                nextMovie();
                              } else if (orientation ==
                                  CardSwipeOrientation.RIGHT) {
                                print("Card is RIGHT swiping");
                                print(movieData.length);
                                resetBackgroundColor();
                                likedMovie();
                                nextMovie();
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                controller.triggerLeft();
                              },
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              child: FaIcon(
                                FontAwesomeIcons.times,
                                size: 40,
                                color: Colors.black.withOpacity(.8),
                              ),
                              padding: EdgeInsets.all(8),
                              shape: CircleBorder(),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                controller.triggerRight();
                              },
                              elevation: 2.0,
                              fillColor: Colors.lightGreenAccent,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                size: 40,
                                color: Colors.black.withOpacity(.8),
                              ),
                              padding: EdgeInsets.all(8),
                              shape: CircleBorder(),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: ButtonTheme(
                      //     child: RaisedButton(
                      //       child: Text('View on IMDB'),
                      //       onPressed: () {
                      //         launchURL(
                      //             imdbURL + movieData[movieIndex]['imdbID']);
                      //       },
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
