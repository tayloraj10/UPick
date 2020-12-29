import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upick_test/constants.dart';
import 'swiper.dart';

class SessionStarterPage extends StatefulWidget {
  List<Map<dynamic, dynamic>> movieData;

  SessionStarterPage({this.movieData});

  @override
  _SessionStarterPageState createState() => _SessionStarterPageState();
}

class _SessionStarterPageState extends State<SessionStarterPage> {
  String sessionCode5 = '';
  String sessionId = '';
  int userNum = 1;
  TextEditingController textEditingController = TextEditingController();
  var firestore = FirebaseFirestore.instance.collection('sessions');

  @override
  Widget build(BuildContext context) {
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
                      print(sessionCode5);
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
              RaisedButton(
                color: Colors.red,
                onPressed: () {
                  var session = firestore.add({
                    'data': getRandomMovies(10, widget.movieData),
                    'likes': {},
                  }).then((value) {
                    print(value.id);
                    setState(() {
                      sessionId = value.id;
                    });
                    textEditingController.text = sessionId.substring(0, 5);
                    firestore
                        .doc(sessionId)
                        .update({'id': sessionId.substring(0, 5)});
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Generate Session',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              RaisedButton(
                color: Colors.yellow,
                onPressed: sessionCode5.length == 5
                    ? () {
                        //TODO handle inputing bad session id
                        var currentSessionData;
                        var currentSessionId;
                        int userCount;
                        var currentSession = firestore
                            .where('id', isEqualTo: sessionCode5)
                            .get()
                            .then((value) {
                          currentSessionData = value.docs.single.data();
                          currentSessionId = value.docs.single.id;
                          var likes = currentSessionData['likes'];
                          userCount = currentSessionData['likes'].length;
                          likes['user${userCount + 1}'] = [];
                          firestore
                              .doc(currentSessionId)
                              .update({'likes': likes});
                        }).then((value) {
                          List<Map<dynamic, dynamic>> newDataList = [];
                          for (var d in currentSessionData['data']) {
                            Map<dynamic, dynamic> newData =
                                Map<dynamic, dynamic>.from(d);
                            newDataList.add(newData);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Swiper(
                                movieData: newDataList,
                                isSession: true,
                                userNum: userCount + 1,
                                sessionCode: currentSessionData['id'],
                                sessionID: currentSessionId,
                              ),
                            ),
                          );
                        });
                      }
                    : null,
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
              // RaisedButton(
              //   color: Colors.blue,
              //   onPressed: code.length == 5 ? () {} : null,
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Text(
              //       'Continue',
              //       style: TextStyle(
              //           fontSize: 26,
              //           fontFamily: 'NunitoSans',
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
