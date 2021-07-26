import 'package:flutter/material.dart';
import 'package:upick_test/constants.dart';

class StreamingIcon extends StatelessWidget {
  final String url;
  final String link;
  final String image_name;

  StreamingIcon({@required this.url, @required this.image_name, this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchURL(link);
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(60, 0, 0, 0),
                  blurRadius: 5.0,
                  offset: Offset(5.0, 5.0))
            ],
            image: DecorationImage(
                fit: BoxFit.fill,
                // image: NetworkImage(url),
                image: AssetImage(image_name)),
          ),
        ),
      ),
    );
  }
}
