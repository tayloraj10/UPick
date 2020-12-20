import 'package:flutter/material.dart';

class MovieDetailSection extends StatelessWidget {
  String title;
  String text;

  MovieDetailSection({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.blue[500],
        ),
        Text(
          title,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 24,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            text ?? '',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
