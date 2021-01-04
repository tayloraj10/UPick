import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_screen.dart';
import 'package:upick_test/sample_data.dart';

//TODO have loading screen get banner data from realtime database

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getBannerData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getBannerData() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    List<Map<dynamic, dynamic>> bannerData = [];
    await databaseReference.once().then((DataSnapshot snapshot) {
      for (var b in snapshot.value) {
        List<Map<dynamic, dynamic>> newData = [];
        for (var a in b['Data']) {
          newData.add(a);
        }
        b['Data'] = newData;
        bannerData.add(b);
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          homeBanners: homeBanners,
        ),
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
