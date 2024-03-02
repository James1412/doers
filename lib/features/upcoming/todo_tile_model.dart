import 'package:flutter/material.dart';

class ToDoTileModel {
  String text;
  DateTime date;
  ValueNotifier<bool> isChecked;
  ValueNotifier<bool> isEditing = ValueNotifier(false);
  ToDoTileModel(
      {required this.date,
      required this.text,
      required this.isChecked,
      required this.isEditing});

  ToDoTileModel.fromJson({required Map json})
      : text = json['text'],
        date = json['date'],
        isChecked = ValueNotifier(json['isChecked']),
        isEditing = ValueNotifier(json['isEditing']);

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "date": date,
      "isChecked": isChecked.value,
      "isEditing": isEditing.value,
    };
  }
}
