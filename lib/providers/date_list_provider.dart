import 'dart:io';

import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/repos/date_list_repo.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class DateListProvider extends ChangeNotifier {
  // Get from database
  late List dbDateList = dateListRepo.getTiles();
  // Convert it into models
  late List<DateTileModel> dateList = [
    for (Map<dynamic, dynamic> tile in dbDateList)
      DateTileModel.fromJson(json: tile),
  ];

  final dateListRepo = DateListRepository();

  void addDate(DateTileModel date) {
    dateList.add(date);
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
    notifyListeners();
  }

  void removeDate(DateTileModel date) {
    dateList.remove(date);
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
    notifyListeners();
  }

  void addEvent(ToDoTileModel event) {
    for (DateTileModel date in dateList) {
      if (getDate(date.date) == getDate(event.date)) {
        date.events.add(event);
        List<Map<String, dynamic>> dateJson = [];
        for (DateTileModel date in dateList) {
          dateJson.add(date.toJson());
        }
        dateListRepo.updateTiles(dateJson);
        notifyListeners();
        return;
      }
    }
    dateList.add(DateTileModel(date: event.date, events: [event]));
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
    notifyListeners();
  }

  void removeEvent(ToDoTileModel event) {
    for (DateTileModel date in dateList) {
      if (getDate(date.date) == getDate(event.date)) {
        date.events.remove(event);
        List<Map<String, dynamic>> dateJson = [];
        for (DateTileModel date in dateList) {
          dateJson.add(date.toJson());
        }
        dateListRepo.updateTiles(dateJson);
        notifyListeners();
      }
    }
  }

  void onSubmittedTap(
      ToDoTileModel event, String value, DateTileModel dateTile, int index) {
    for (DateTileModel date in dateList) {
      if (getDate(date.date) == getDate(event.date)) {
        for (ToDoTileModel eachEvent in date.events) {
          if (eachEvent == event) {
            eachEvent.text = value;
            event.isEditing.value = !event.isEditing.value;
          }
        }
        List<Map<String, dynamic>> dateJson = [];
        for (DateTileModel date in dateList) {
          dateJson.add(date.toJson());
        }
        dateListRepo.updateTiles(dateJson);
        notifyListeners();
      }
    }
  }

  void onReorder(int oldIndex, int newIndex, DateTileModel dateTile) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = dateList[dateList.indexOf(dateTile)].events.removeAt(oldIndex);
    dateList[dateList.indexOf(dateTile)].events.insert(newIndex, item);
    notifyListeners();
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
  }

  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    if (getDate(receivedData.data.date) == getDate(dateTile.date)) {
      isDraggedToSameDate = true;
      return;
    } else {
      isDraggedToSameDate = false;
      receivedData.data.date = dateTile.date;
      dateList[dateList.indexOf(dateTile)].events.add(receivedData.data);
    }
    notifyListeners();
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
  }

  bool isDraggedToSameDate = false;
  void onDragComplete(DateTileModel dateTile, ToDoTileModel event) {
    if (isDraggedToSameDate) return;
    dateList[dateList.indexOf(dateTile)].events.remove(event);
    notifyListeners();
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
  }

  Future<bool> onCheckTap(ToDoTileModel event) async {
    //Vibration
    if (Platform.isAndroid) {
      if (await Vibration.hasVibrator() != null &&
          await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 100);
      }
    } else if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    }
    event.isChecked.value = !event.isChecked.value;
    List<Map<String, dynamic>> dateJson = [];
    for (DateTileModel date in dateList) {
      dateJson.add(date.toJson());
    }
    dateListRepo.updateTiles(dateJson);
    return event.isChecked.value;
  }

  bool isDeclinedDate = false;
  void setDeclinedDate(bool value) {
    isDeclinedDate = value;
    notifyListeners();
  }
}
