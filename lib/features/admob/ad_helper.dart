import 'dart:io';

class HomeScreenAdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/3748361058';
    }
    throw UnsupportedError("Unsupported platform");
  }
}

class ChartScreenAdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/6155032541';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
