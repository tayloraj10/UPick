import 'package:flutter/material.dart';
import 'package:upick_test/components/streaming_section.dart';

class StreamingIconTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamingSection(
            streamingData: [
              {'Netflix': ''},
              {'Hulu': ''},
              {'Amazon Prime Video': ''},
              {'HBO Max': ''},
              {'HBO Now': ''},
              {'Disney Plus': ''},
              {'Tubi TV': ''},
              {'fuboTV': ''},
              {'Hoopla': ''},
              {'VUDU Free': ''},
              {'Starz': ''},
              {'Peacock Premium': ''},
              {'Crackle': ''},
              {'Sling TV': ''},
            ],
          ),
        ],
      ),
    );
  }
}
