import 'package:doers/box_name.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

final tileBox = Hive.box(dateListBox);

class DateListRepository {
  void updateTiles(List<Map<String, dynamic>> tiles) {
    tileBox.put(dateListBox, tiles);
  }

  List getTiles() {
    return tileBox.get(dateListBox) ??
        [
          DateTileModel(
            date: DateTime.now(),
            events: [],
          ).toJson(),
          DateTileModel(
            date: DateTime.now().add(const Duration(days: 1)),
            events: [],
          ).toJson(),
        ];
  }
}
