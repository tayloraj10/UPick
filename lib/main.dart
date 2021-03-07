import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';
import 'package:upick_test/screens/home_screen.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/screens/loading_screen.dart';
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
    return ChangeNotifierProvider<appData>(
      create: (context) => appData(),
      child: MaterialApp(
        routes: {
          '/home': (context) => HomeScreen(),
          '/swipe': (context) => Swiper(),
          '/liked': (context) => LikedMovies(),
          '/loading': (context) => LoadingScreen()
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          // appBar: UPickAppBar(),
          body: SafeArea(
            child: LoadingScreen(),
          ),
        ),
      ),
    );
  }
}
