import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'swiper.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';

class SessionStarterPage extends StatefulWidget {
  final bool onlyJoin;

  SessionStarterPage({this.onlyJoin = false});

  @override
  _SessionStarterPageState createState() => _SessionStarterPageState();
}

class _SessionStarterPageState extends State<SessionStarterPage> {
  String sessionCode5 = '';
  String sessionId = '';
  int userNum = 0;
  TextEditingController textEditingController = TextEditingController();
  var firestore = FirebaseFirestore.instance.collection('sessions');

  @override
  Widget build(BuildContext context) {
    void generateSession() {
      firestore.add({
        'data': Provider.of<AppData>(context, listen: false).getNMovies(10),
        'likes': {},
      }).then((value) {
        setState(() {
          sessionId = value.id;
        });
        textEditingController.text = sessionId.substring(0, 5);
        firestore.doc(sessionId).update({'id': sessionId.substring(0, 5)});
      });
    }

    void joinSession() {
      var currentSessionData;
      var currentSessionId;
      int userCount;
      firestore.where('id', isEqualTo: sessionCode5).get().then((value) {
        bool empty = value.docs.isEmpty;
        if (empty) {
          final snackBar = SnackBar(
            content: Text(
              'Session ID not found!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.lightBlueAccent,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          currentSessionData = value.docs.single.data();

          currentSessionId = value.docs.single.id;
          var likes = currentSessionData['likes'];
          userCount = currentSessionData['likes'].length;

          List moviesList = [];
          for (var m in currentSessionData['data']) {
            moviesList.add(m['Title']);
          }
          likes['user${userCount + 1}'] = moviesList;
          firestore.doc(currentSessionId).update({'likes': likes});
        }
      }).then((value) {
        if (currentSessionId != null) {
          List<Map<dynamic, dynamic>> newDataList = [];
          for (var d in currentSessionData['data']) {
            Map<dynamic, dynamic> newData = Map<dynamic, dynamic>.from(d);
            newDataList.add(newData);
          }

          Provider.of<AppData>(context, listen: false)
              .updateMovieData(newDataList);
          Provider.of<AppData>(context, listen: false).updateSessionInfo(
              newSession: true,
              newUserNum: userCount + 1,
              newSessionCode: currentSessionData['id'],
              newSessionID: currentSessionId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Swiper(),
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: UPickAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Session ID',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PinPut(
                    keyboardType: TextInputType.text,
                    controller: textEditingController,
                    onChanged: (String value) {
                      setState(() {
                        sessionCode5 = value;
                      });
                    },
                    fieldsCount: 5,
                    textStyle: TextStyle(fontSize: 25.0, color: Colors.black),
                    fieldsAlignment: MainAxisAlignment.spaceEvenly,
                    followingFieldDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        width: 2,
                        color: Colors.blue,
                      ),
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    submittedFieldDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        width: 2,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              if (!widget.onlyJoin)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: generateSession,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Start a New Session',
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                onPressed: sessionCode5.length == 5 ? joinSession : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Join Session',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
