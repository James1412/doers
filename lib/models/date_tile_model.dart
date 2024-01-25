import 'package:doers/models/todo_tile_model.dart';

class DateTileModel {
  DateTime date;
  List<ToDoTileModel> events;

  DateTileModel({required this.date, required this.events});
}
