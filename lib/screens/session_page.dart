import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/screens/swipe_screen.dart';

class SessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(),
      body: SafeArea(
        child: Session(),
      ),
    );
  }
}

class Session extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  String code = '';
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
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
                controller: textEditingController,
                onChanged: (String value) {
                  setState(() {
                    code = value;
                  });
                  print(code);
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
              textEditingController.text = '12345';
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
            onPressed: code.length == 5
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SwipeScreen(),
                      ),
                    );
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
    );
  }
}
