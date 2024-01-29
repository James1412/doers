import 'dart:io';

class HomeScreenAdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/2145287739';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/3748361058';
    }
    throw UnsupportedError("Unsupported platform");
  }
}

class ChartScreenAdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/4579879387';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/6155032541';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
