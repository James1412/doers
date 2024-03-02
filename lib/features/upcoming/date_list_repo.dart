import 'package:doers/box_name.dart';
import 'package:doers/features/upcoming/date_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

final tileBox = Hive.box(dateListBox);

class DateListRepository {
  Future<void> updateTiles(List<Map<String, dynamic>> tiles) async {
    await tileBox.put(dateListBox, tiles);
  }

  List getTiles() {
    return tileBox.get(dateListBox) ??
        [
          DateTileModel(
            date: currentDay,
            events: [],
          ).toJson(),
          DateTileModel(
            date: currentDay.add(const Duration(days: 1)),
            events: [],
          ).toJson(),
        ];
  }
}
