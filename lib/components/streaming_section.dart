import 'package:flutter/material.dart';
import 'package:upick_test/components/streaming_icon.dart';
import 'package:upick_test/constants.dart';

class StreamingSection extends StatelessWidget {
  final List streamingData;

  StreamingSection({@required this.streamingData});

  List<Widget> streamingIcons(List data) {
    List<Widget> icons = [];
    data.forEach((e) {
      // print(e.keys.toList()[0].toString());
      // print(streaming_services[e.keys.toList()[0].toString()]);
      // print(e.values.toList()[0]);
      if (streamingServices.containsKey(e.keys.toList()[0].toString())) {
        icons.add(
          StreamingIcon(
            // url: streaming_services[e.keys.toList()[0].toString()],
            url: e.values.toList()[0],
            imageName:
                "assets/streaming_icons/${streamingServicesIcons[e.keys.toList()[0].toString()]}",
          ),
        );
      }
    });
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            'Streaming Availability',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 24,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          streamingIcons(streamingData).length >= 1
              ? Container(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: streamingIcons(streamingData),
                  ),
                )
              : Text(
                  'Streaming Availability Unknown',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.bold,
                  ),
                )
        ],
      ),
    );
  }
}
