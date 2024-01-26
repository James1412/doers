import 'package:doers/box_name.dart';
import 'package:hive_flutter/hive_flutter.dart';

final colorBox = Hive.box(colorBoxName);

class ColorRepository {
  Future<void> setColor(int colorhex) async {
    colorBox.put(colorBoxName, colorhex);
  }

  int getColor() {
    return colorBox.get(colorBoxName) ?? 0xFF2196F3;
  }
}
