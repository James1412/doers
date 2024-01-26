import 'package:doers/box_name.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

final tileBox = Hive.box(allDateListBox);

class AllDateListRepository {
  Future<void> updateTiles(List<Map<String, dynamic>> tiles) async {
    await tileBox.put(allDateListBox, tiles);
  }

  List getTiles() {
    return tileBox.get(allDateListBox) ??
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
