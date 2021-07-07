import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7421687202206238~4075089492";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7421687202206238~1719498241";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7421687202206238/2570436134";
      // return "ca-app-pub-3940256099942544/1033173712"; //test ad
    } else if (Platform.isIOS) {
      return "ca-app-pub-7421687202206238/5440564488";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
