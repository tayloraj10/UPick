import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Finding your movies',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
                color: Colors.blue),
          ),
        )
      ],
    );
  }
}
