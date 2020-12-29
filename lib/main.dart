import 'package:flutter/material.dart';
import 'package:upick_test/screens/home_screen.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/screens/loading_screen.dart';
import 'package:upick_test/screens/movie_detail_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upick_test/screens/swiper.dart';

// void main() => runApp(MyApp());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeScreen(),
        '/swipe': (context) => Swiper(),
        '/liked': (context) => LikedMovies(),
        '/movie_detail': (context) => MovieDetailPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // appBar: UPickAppBar(),
        body: SafeArea(
          //TODO make a loading screen
          child: LoadingScreen(),
        ),
      ),
    );
  }
}
