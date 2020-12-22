import 'package:flutter/material.dart';

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
