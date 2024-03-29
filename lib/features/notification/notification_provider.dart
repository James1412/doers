import 'package:doers/features/notification/notification_repo.dart';
import 'package:doers/features/notification/notification_service.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final db = NotificationRepo();
  late bool isNotificationOn = db.getNoti();
  Future<void> setNotifications() async {
    isNotificationOn = true;
    db.setNoti(true);
    // 6PM
    await NotificationService().scheduleNotification(
        scheduledNotificationDateTime: currentDay.add(const Duration(hours: 6)),
        title: "Check your to do list!",
        body: "or create one!",
        id: 1);

    // 10AM
    await NotificationService().scheduleNotification(
        scheduledNotificationDateTime:
            currentDay.add(const Duration(hours: 10)),
        title: "Check your to do list!",
        body: "or create one!",
        id: 2);

    // 3PM
    await NotificationService().scheduleNotification(
        scheduledNotificationDateTime:
            currentDay.add(const Duration(hours: 15)),
        title: "Check your to do list!",
        body: "or create one!",
        id: 3);

    // 9PM
    await NotificationService().scheduleNotification(
        scheduledNotificationDateTime:
            currentDay.add(const Duration(hours: 21)),
        title: "Check your to do list!",
        body: "or create one!",
        id: 4);
    notifyListeners();
  }

  Future<void> cancelNotifications() async {
    isNotificationOn = false;
    db.setNoti(false);
    await NotificationService().cancelAllNotification();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool isNoti) async {
    if (isNoti) {
      isNotificationOn = true;
      setNotifications();
    } else {
      isNotificationOn = false;
      cancelNotifications();
    }
    notifyListeners();
  }
}
