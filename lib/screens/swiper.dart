import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:upick_test/constants.dart';
import 'package:upick_test/screens/ad_mob.dart';
import 'package:upick_test/screens/movie_detail_page.dart';
import 'package:upick_test/utilities/fetch_url.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';

class Swiper extends StatefulWidget {
  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with TickerProviderStateMixin {
  Color backgroundColor = appBackgroundColor;
  FetchURL fetcher = FetchURL();
  bool swipingFinished = false;

  int movieIndex = 0;

  List movieData = [];
  List<Map<dynamic, dynamic>> likedMovies = [];

  var firestore = FirebaseFirestore.instance.collection('sessions');
  var firestoreData;

  void setMovieData() {
    setState(() {
      movieData = Provider.of<AppData>(context, listen: false).getNMovies(10);
    });
  }

  Future<void> setFirestoreData(List likedMoviesList) async {
    await firestore
        .where('id',
            isEqualTo: Provider.of<AppData>(context, listen: false).sessionCode)
        .get()
        .then((value) {
      setState(() {
        firestoreData = value.docs.single.data();
        firestoreData['likes'][
                'user${Provider.of<AppData>(context, listen: false).userNum}'] =
            likedMoviesList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setMovieData();
  }

  void nextMovie() async {
    if (movieIndex == movieData.length - 1) {
      if (Provider.of<AppData>(context, listen: false).isSession) {
        setState(() {
          swipingFinished = true;
        });

        List likedMoviesList = [];

        for (var m in likedMovies) {
          likedMoviesList.add(m['Title']);
        }

        await setFirestoreData(likedMoviesList);

        firestore
            .doc(Provider.of<AppData>(context, listen: false).sessionID)
            .update({'likes': firestoreData['likes']});
      }

      Provider.of<AppData>(context, listen: false)
          .updateLikedMovies(likedMovies);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InterstitialAdmob(),
        ),
      );
    } else {
      setState(() {
        movieIndex++;
      });
    }
  }

  void likedMovie() {
    setState(() {
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
        body: movieData.length == 0
            ? Container(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No movies were found for this selection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Take Me Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
              )
            : swipingFinished
                ? Center(child: CircularProgressIndicator())
                : Column(
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
                                    minHeight:
                                        MediaQuery.of(context).size.height - 50,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Provider.of<AppData>(context).isSession
                                          ? Column(
                                              children: [
                                                SelectableText(
                                                  'Session ID: ${Provider.of<AppData>(context).sessionID.substring(0, 5)}',
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        onTap: () {
                                          launchURL(imdbURL +
                                              movieData[movieIndex]['imdbID']);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text.rich(
                                          TextSpan(
                                            text: (movieData[movieIndex]
                                                            ['Plot'] ??
                                                        '') ==
                                                    'N/A'
                                                ? 'No plot available'
                                                : movieData[movieIndex]
                                                        ['Plot'] ??
                                                    '',
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
                                              builder: (context) =>
                                                  MovieDetailPage(
                                                      movieData: movieData[
                                                          movieIndex]),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: TinderSwapCard(
                                            orientation:
                                                AmassOrientation.BOTTOM,
                                            totalNum: movieData.length,
                                            stackNum: 2,
                                            swipeEdge: 4.0,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            minHeight: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            cardBuilder: (context, index) {
                                              // print('index ${index}');
                                              return Card(
                                                child: Hero(
                                                  child: Image.network(
                                                      '${movieData[index]['Poster']}' ==
                                                              'N/A'
                                                          ? noPosterUrl
                                                          : '${movieData[index]['Poster']}'),
                                                  tag: movieData[index]
                                                      ['Title'],
                                                ),
                                              );
                                            },
                                            cardController: controller =
                                                CardController(),
                                            swipeUpdateCallback:
                                                (DragUpdateDetails details,
                                                    Alignment align) {
                                              /// Get swiping card's alignment
                                              // print(align);
                                              if (align.x < -1) {
                                                // print("Card is LEFT swiping");
                                                setState(() {
                                                  backgroundColor =
                                                      Colors.redAccent;
                                                });
                                              } else if (align.x > 1) {
                                                // print("Card is RIGHT swiping");
                                                setState(() {
                                                  backgroundColor =
                                                      Colors.lightGreenAccent;
                                                });
                                              } else {
                                                resetBackgroundColor();
                                              }
                                            },
                                            swipeCompleteCallback:
                                                (CardSwipeOrientation
                                                        orientation,
                                                    int index) {
                                              // print(orientation.toString());
                                              if (orientation ==
                                                  CardSwipeOrientation
                                                      .RECOVER) {
                                                // print("Card Recovered");
                                                resetBackgroundColor();
                                              } else if (orientation ==
                                                  CardSwipeOrientation.LEFT) {
                                                // print("Card is LEFT swiping");
                                                resetBackgroundColor();
                                                nextMovie();
                                              } else if (orientation ==
                                                  CardSwipeOrientation.RIGHT) {
                                                // print("Card is RIGHT swiping");
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
                                                color: Colors.black
                                                    .withOpacity(.8),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              shape: CircleBorder(),
                                            ),
                                            RawMaterialButton(
                                              onPressed: () {
                                                controller.triggerRight();
                                              },
                                              elevation: 2.0,
                                              fillColor:
                                                  Colors.lightGreenAccent,
                                              child: FaIcon(
                                                FontAwesomeIcons.check,
                                                size: 40,
                                                color: Colors.black
                                                    .withOpacity(.8),
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
                  ));
  }
}
