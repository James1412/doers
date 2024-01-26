import 'package:doers/repos/color_repo.dart';
import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  final db = ColorRepository();

  int get colorhex => db.getColor();

  void setColor(int hexcode) {
    db.setColor(hexcode);
    notifyListeners();
  }
}
