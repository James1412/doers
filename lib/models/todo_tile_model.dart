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
}
