import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/screens/session_starter_page.dart';
import 'swiper.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';

class SessionChooserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void chooseWithFriends() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SessionStarterPage(),
        ),
      );
    }

    void chooseByYourself() {
      Provider.of<appData>(context, listen: false).updateIsSession(false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Swiper(),
        ),
      );
    }

    return Scaffold(
      appBar: UPickAppBar(),
      body: SafeArea(
        child: Padding(
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
                      child: Center(
                        child: Text(
                          'Choose with Friends',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: chooseWithFriends,
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
                      child: Center(
                        child: Text(
                          'Choose by Yourself',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: chooseByYourself,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
