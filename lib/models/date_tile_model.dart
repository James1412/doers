import 'package:doers/models/todo_tile_model.dart';

class DateTileModel {
  late DateTime date;
  late List<ToDoTileModel> events;

  DateTileModel({required this.date, required this.events});
  DateTileModel.fromJson({required Map json})
      : date = json['date'],
        events = [
          for (var event in json['events']) ToDoTileModel.fromJson(json: event)
        ];

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> newEvents = [];
    for (ToDoTileModel event in events) {
      newEvents.add(event.toJson());
    }
    return {
      "date": date,
      "events": newEvents,
    };
  }
}
