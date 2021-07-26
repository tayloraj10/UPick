import 'package:flutter/material.dart';
import 'package:upick_test/screens/extra.dart';
import 'package:upick_test/screens/home_screen.dart';
import 'package:upick_test/screens/home_screen_old.dart';
import 'package:upick_test/screens/session_starter_page.dart';

class UPickAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool showBack;
  bool showJoinSession;
  bool showExtraPage;

  @override
  final Size preferredSize;

  UPickAppBar(
      {this.showBack = true,
      this.showJoinSession = false,
      this.showExtraPage = false,
      this.preferredSize = const Size.fromHeight(kToolbarHeight)});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: showBack,
      centerTitle: true,
      elevation: 10,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
        child: Text(
          'UPick',
          style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic),
        ),
      ),
      leading: showJoinSession
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionStarterPage(
                        onlyJoin: true,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.phonelink_ring_rounded,
                  size: 34,
                ),
              ),
            )
          : null,
      actions: showExtraPage
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExtraScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.queue_play_next_sharp,
                    size: 36,
                  ),
                ),
              )
            ]
          : [],
    );
  }
}

// UPickAppBar(
//     {bool showBack = true,
//     bool showJoinSession = false,
//     bool showExtraPage = false}) {
//   return AppBar(
//     automaticallyImplyLeading: showBack,
//     centerTitle: true,
//     elevation: 10,
//     titleSpacing: 0,
//     title: Text(
//       'UPick',
//       style: TextStyle(
//           color: Colors.white,
//           fontSize: 40,
//           fontFamily: 'NunitoSans',
//           fontWeight: FontWeight.w700,
//           fontStyle: FontStyle.italic),
//     ),
//     leading: showJoinSession
//         ? GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CustomCategoriesPicker(),
//                 ),
//               );
//             },
//             child: Icon(
//               Icons.phonelink_ring_rounded,
//               size: 32,
//             ),
//           )
//         : null,
//   );
// }
