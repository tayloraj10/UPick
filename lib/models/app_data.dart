import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:upick_test/constants.dart';

class AppData extends ChangeNotifier {
  List<Map<dynamic, dynamic>> homeBanners = [];
  List<Map<dynamic, dynamic>> extraBanners = [];
  List<Map<dynamic, dynamic>> movieData = [];
  List<Map<dynamic, dynamic>> likedMovies = [];
  bool isSession = false;
  int userNum = 0;
  String sessionCode = '';
  String sessionID = '';
  var firebase;

  List getNMovies(int n) {
    return getRandomMovies(n, movieData);
  }

  get getMovies {
    return movieData;
  }

  void updateFirebaseApp(FirebaseApp newApp) {
    firebase = FirebaseDatabase(
            app: newApp, databaseURL: 'https://upick-movie-data.firebaseio.com')
        .reference();
    notifyListeners();
  }

  void updateMoviesPopular() async {
    await firebase
        .orderByChild('popular')
        .equalTo(true)
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value.length);
    });

    // await firebase.once().then((DataSnapshot snapshot) {
    //   print(snapshot.value);
    // });
    notifyListeners();
  }

  void updateHomeBannerData(List<Map<dynamic, dynamic>> newData) {
    homeBanners = newData;
    notifyListeners();
  }

  void updateExtraBannerData(List<Map<dynamic, dynamic>> newData) {
    extraBanners = newData;
    notifyListeners();
  }

  void updateMovieData(List<Map<dynamic, dynamic>> newData) {
    movieData = newData;
    notifyListeners();
  }

  void updateLikedMovies(List<Map<dynamic, dynamic>> newData) {
    likedMovies = newData;
    notifyListeners();
  }

  void updateIsSession(bool newData) {
    isSession = newData;
    notifyListeners();
  }

  void updateUserNum(int newData) {
    userNum = newData;
    notifyListeners();
  }

  void updateSessionCode(String newData) {
    sessionCode = newData;
    notifyListeners();
  }

  void updateSessionID(String newData) {
    sessionID = newData;
    notifyListeners();
  }

  void updateSessionInfo(
      {bool newSession,
      int newUserNum,
      String newSessionCode,
      String newSessionID}) {
    isSession = newSession;
    userNum = newUserNum;
    sessionCode = newSessionCode;
    sessionID = newSessionID;
    notifyListeners();
  }
}
