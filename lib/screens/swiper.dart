import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:upick_test/constants.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/screens/movie_detail_page.dart';
import 'package:upick_test/utilities/fetch_url.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Swiper extends StatefulWidget {
  List<Map<dynamic, dynamic>> movieData;
  bool isSession;
  int userNum;
  String sessionCode;
  String sessionID;

  Swiper(
      {@required this.movieData,
      this.isSession = false,
      this.userNum = 0,
      this.sessionCode = '',
      this.sessionID = ''});

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with TickerProviderStateMixin {
  Color backgroundColor = appBackgroundColor;
  FetchURL fetcher = FetchURL();
  bool swipingFinished = false;

  int movieIndex = 0;

  List movieData = []; //sampleData;
  List<Map> likedMovies = [];

  var firestore = FirebaseFirestore.instance.collection('sessions');
  var firestoreData;

  void setMovieData() {
    setState(() {
      movieData = getRandomMovies(10, widget.movieData);
      // movieData = widget.movieData;
    });
  }

  void setFirestoreData() {
    firestore.where('id', isEqualTo: widget.sessionCode).get().then((value) {
      setState(() {
        firestoreData = value.docs.single.data();
      });
      // print(firestoreData);
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchMovieData();
    setMovieData();
    if (widget.isSession) {
      print('fetching firestore data');
      setFirestoreData();
    }
  }

  Future<void> fetchMovies() async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$movie_db_api_key&language=en-US';
    print(url);
    var data = await fetcher.getData(url);
  }

  void nextMovie() {
    print('next movie');
    if (movieIndex == movieData.length - 1) {
      print('finished movies');
      if (widget.isSession) {
        List likedMoviesList = [];

        for (var m in likedMovies) {
          likedMoviesList.add(m['Title']);
        }

        setFirestoreData();

        setState(() {
          firestoreData['likes']['user${widget.userNum}'] = likedMoviesList;
        });

        firestore
            .doc(widget.sessionID)
            .update({'likes': firestoreData['likes']});
      }

      print(likedMovies);
      print(widget.isSession);
      print(widget.userNum);
      print(widget.sessionID);
      print(widget.sessionCode);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LikedMoviesPage(
            likedMovies: likedMovies,
            isSession: widget.isSession,
            userNum: widget.userNum,
            sessionID: widget.sessionID,
            sessionCode: widget.sessionCode,
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
    return Scaffold(
      appBar: UPickAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.isSession
                              ? Column(
                                  children: [
                                    SelectableText(
                                      'Session ID: ${widget.sessionID.substring(0, 5)}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                              : Container(),
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
                              launchURL(
                                  imdbURL + movieData[movieIndex]['imdbID']);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text.rich(
                              TextSpan(
                                text: (movieData[movieIndex]['Plot'] ?? '') ==
                                        'N/A'
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.9,
                                maxHeight:
                                    MediaQuery.of(context).size.width * 0.9,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                                minHeight:
                                    MediaQuery.of(context).size.width * 0.8,
                                cardBuilder: (context, index) {
                                  // print('index ${index}');
                                  return Card(
                                    child: Hero(
                                      child: Image.network(
                                          '${movieData[index]['Poster']}' ==
                                                  'N/A'
                                              ? noPosterUrl
                                              : '${movieData[index]['Poster']}'),
                                      tag: movieData[index]['Title'],
                                    ),
                                  );
                                },
                                cardController: controller = CardController(),
                                swipeUpdateCallback: (DragUpdateDetails details,
                                    Alignment align) {
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
                                    (CardSwipeOrientation orientation,
                                        int index) {
                                  // print(orientation.toString());
                                  if (orientation ==
                                      CardSwipeOrientation.RECOVER) {
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
