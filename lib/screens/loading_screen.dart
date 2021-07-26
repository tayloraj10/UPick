import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:upick_test/screens/home_screen.dart';
import 'home_screen_old.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';

class LoadingScreen extends StatefulWidget {
  final FirebaseApp app;

  LoadingScreen({this.app});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    final FirebaseApp app = await Firebase.initializeApp();
    Provider.of<appData>(context, listen: false).updateFirebaseApp(app);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<void> getBannerData() async {
    // final databaseReference = FirebaseDatabase.instance.reference();
    final databaseReference = FirebaseDatabase(
            app: widget.app,
            databaseURL: 'https://upick-775b7-bb6c3.firebaseio.com')
        .reference();
    List<Map<dynamic, dynamic>> homeBannerData = [];
    List<Map<dynamic, dynamic>> extraBannerData = [];
    await databaseReference.once().then((DataSnapshot snapshot) {
      for (var b in snapshot.value) {
        if (b['FrontPage']) {
          List<Map<dynamic, dynamic>> newData = [];
          for (var a in b['Data']) {
            newData.add(a);
          }
          b['Data'] = newData;
          homeBannerData.add(b);
        } else if (!b['FrontPage']) {
          List<Map<dynamic, dynamic>> newData = [];
          for (var a in b['Data']) {
            newData.add(a);
          }
          b['Data'] = newData;
          extraBannerData.add(b);
        }
      }
    });

    Provider.of<appData>(context, listen: false)
        .updateHomeBannerData(homeBannerData);
    Provider.of<appData>(context, listen: false)
        .updateExtraBannerData(extraBannerData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
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
