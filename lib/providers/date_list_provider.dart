import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';

class DateListProvider extends ChangeNotifier {
  List<DateTileModel> dateList = [
    DateTileModel(
      date: DateTime.now(),
      events: [
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay,
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay,
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay,
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay,
            text: 'hi',
            isChecked: ValueNotifier(false)),
      ],
    ),
    DateTileModel(
      date: DateTime.now().add(const Duration(days: 1)),
      events: [
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay.add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay.add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay.add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: currentDay.add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
      ],
    ),
  ];
  void addDate(DateTileModel date) {
    dateList.add(date);
    notifyListeners();
  }

  void removeDate(DateTileModel date) {
    dateList.remove(date);
    notifyListeners();
  }
}
