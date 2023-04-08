import 'package:cloud_firestore/cloud_firestore.dart';
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
  var moviesDatabase = FirebaseFirestore.instance.collection('movies');
  bool loading = false;

  void updateLoading(bool loadingStatus) {
    loading = loadingStatus;
    notifyListeners();
  }

  get getLoading {
    return loading;
  }

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

  void filterAllMovies(
      String streaming, String genre, String rating, double score) async {
    movieData = [];
    await moviesDatabase.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          bool meetsFilters = true;
          var data = docSnapshot.data();
          // print(docSnapshot.data());
          if (streaming != null) {
            print(streaming);
            if (!(data['streaming_options'].contains(streaming))) {
              meetsFilters = false;
            }
          }
          if (genre != null) {
            if (!(data['Genres'].contains(genre))) {
              meetsFilters = false;
            }
          }
          if (rating != null) {
            if (!(data['Rated'].contains(rating))) {
              meetsFilters = false;
            }
          }
          if (score != null) {
            if (score == 5) score = 4.5;
            if (data['Rating'] != 'N/A' &&
                !(double.parse(data['Rating']) >= score * 2)) {
              meetsFilters = false;
            } else if (data['Rating'] == 'N/A') {
              meetsFilters = false;
            }
          }
          if (meetsFilters) {
            movieData.add(docSnapshot.data());
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(movieData.length);
    notifyListeners();
  }

  void updateMoviesMain(String type) async {
    movieData = [];
    await moviesDatabase.where(type, isEqualTo: true).get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          movieData.add(docSnapshot.data());
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    notifyListeners();
  }

  void updateMoviesStreaming(String type) async {
    Map typeMap = {
      'netflix': 'Netflix',
      'hulu': 'Hulu',
      'hbo': 'HBO Max',
      'amazon prime': 'Amazon Prime Video'
    };
    movieData = [];
    await moviesDatabase
        .where('streaming_options', arrayContains: typeMap[type])
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          movieData.add(docSnapshot.data());
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
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
