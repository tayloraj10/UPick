import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';
import 'package:upick_test/screens/home_screen_old.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/screens/loading_screen.dart';
import 'package:upick_test/screens/swiper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// void main() => runApp(MyApp());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp(
      // app: app,
      ));
}

class MyApp extends StatelessWidget {
  // final FirebaseApp app;
  //
  // MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomeScreenOld(),
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
            child:
                // StreamingIconTest()
                // InterstitialAdmob(),
                //     LoadingScreen(
                //   app: app,
                // ),
                LoadingScreen(),
          ),
        ),
      ),
    );
  }
}
