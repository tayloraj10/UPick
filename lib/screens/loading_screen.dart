import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:upick_test/sample_data.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => Navigator.pushNamed(context, '/home'));
    finishedLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> finishedLoading() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'UPick',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 40,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
