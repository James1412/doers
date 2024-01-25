import 'package:flutter/material.dart';

class ToDoTileModel {
  String text;
  DateTime date;
  ValueNotifier<bool> isChecked;
  ToDoTileModel(
      {required this.date, required this.text, required this.isChecked});
}
