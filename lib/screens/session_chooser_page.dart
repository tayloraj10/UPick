import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/screens/session_starter_page.dart';
import 'file:///C:/Users/taylo/AndroidStudioProjects/upick_test/lib/screens/swiper.dart';

class SessionChooserPage extends StatelessWidget {
  List<Map<dynamic, dynamic>> movieData;

  SessionChooserPage({@required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(),
      body: SafeArea(
        child: SessionChooser(
          movieData: movieData,
        ),
      ),
    );
  }
}

class SessionChooser extends StatelessWidget {
  List<Map<dynamic, dynamic>> movieData;

  SessionChooser({@required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RaisedButton(
                  shape: CircleBorder(),
                  elevation: 10,
                  color: Colors.red,
                  child: Text(
                    'Choose with Friends',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionStarterPage(
                          movieData: movieData,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 10,
                  color: Colors.blue,
                  child: Text(
                    'Choose by Yourself',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Swiper(
                          movieData: movieData,
                          isSession: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
