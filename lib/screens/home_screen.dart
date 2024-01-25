import 'package:doers/components/date_tile.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DateTileModel> dateList = [
    DateTileModel(
      date: DateTime.now(),
      events: [
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now(),
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now(),
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now(),
            text: 'hi',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now(),
            text: 'hi',
            isChecked: ValueNotifier(false)),
      ],
    ),
    DateTileModel(
      date: DateTime.now().add(const Duration(days: 1)),
      events: [
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            isEditing: ValueNotifier(false),
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
      ],
    ),
  ];

  bool isSameDate = false;

  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    final receivedDate = DateTime(receivedData.data.date.year,
        receivedData.data.date.month, receivedData.data.date.day);
    final dateTileDate =
        DateTime(dateTile.date.year, dateTile.date.month, dateTile.date.day);
    if (receivedDate == dateTileDate) {
      isSameDate = true;
      setState(() {});
      return;
    }
    setState(() {
      isSameDate = false;
      receivedData.data.date = dateTileDate;
      dateTile.events.add(receivedData.data);
    });
  }

  void onDragComplete(dateTile, event) {
    if (isSameDate) return;
    setState(() {
      dateTile.events.remove(event);
    });
  }

  void removeDate(DateTileModel dateTile) {
    setState(() {
      dateList.remove(dateTile);
    });
  }

  void onNewEventTap() {}

  int currentYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              dense: true,
              title: Text(
                currentYear.toString(),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dateList.length,
              itemBuilder: (context, index) {
                return DateTile(
                  dateTile: dateList[index],
                  onAccept: onAccept,
                  getDate: getDate,
                  onDragComplete: onDragComplete,
                  dateList: dateList,
                  isDateToday: isDateToday,
                  removeDate: removeDate,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        splashColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: onNewEventTap,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
