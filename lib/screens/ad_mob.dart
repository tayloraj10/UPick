import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upick_test/screens/liked_movies.dart';
import 'package:upick_test/utilities/ad_manager.dart';

class InterstitialAdmob extends StatefulWidget {
  @override
  _InterstitialAdmobState createState() => _InterstitialAdmobState();
}

class _InterstitialAdmobState extends State<InterstitialAdmob> {
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _interstitialAd.show();
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          ad.dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LikedMoviesPage(),
            ),
          );
        },
        onAdClosed: (_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LikedMoviesPage(),
            ),
          );
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
