import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/components/swiper.dart';
import 'package:upick_test/sample_data.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Swiper(
                movieData: sampleData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
