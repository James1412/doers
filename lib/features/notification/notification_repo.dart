import 'package:doers/box_name.dart';
import 'package:hive/hive.dart';

final notiBox = Hive.box(notiBoxName);

class NotificationRepo {
  Future<void> setNoti(bool noti) async {
    notiBox.put(notiBoxName, noti);
  }

  bool getNoti() {
    return notiBox.get(notiBoxName) ?? false;
  }
}
