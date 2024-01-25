import 'package:doers/components/event_tile.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now(), text: 'hi', isChecked: ValueNotifier(false)),
      ],
    ),
    DateTileModel(
      date: DateTime.now().add(const Duration(days: 1)),
      events: [
        ToDoTileModel(
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
        ToDoTileModel(
            date: DateTime.now().add(const Duration(days: 1)),
            text: 'hi2',
            isChecked: ValueNotifier(false)),
      ],
    ),
  ];

  String getDate(DateTime dateTime) {
    if (isDateToday(dateTime)) {
      return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]}) • Today";
    }
    return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]})";
  }

  bool isDateToday(DateTime dateTime) {
    if (DateTime(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      return true;
    } else {
      return false;
    }
  }

  bool isSameDate = false;
  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    final receivedYear = receivedData.data.date.year;
    final receivedMonth = receivedData.data.date.month;
    final receivedDay = receivedData.data.date.day;
    final receivedDate = DateTime(receivedYear, receivedMonth, receivedDay);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // TODO: Make this sliver app bar and change year based on current index
            ListTile(
              dense: true,
              title: Text(
                DateTime.now().year.toString(),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            // Each day expansion tile
            for (DateTileModel dateTile in dateList)
              DragTarget(
                onAcceptWithDetails:
                    (DragTargetDetails<ToDoTileModel> details) =>
                        onAccept(details, dateTile),
                builder: (context, candidateData, rejectedData) {
                  return Opacity(
                    opacity: candidateData.isNotEmpty ? 0.5 : 1,
                    child: Slidable(
                      key: UniqueKey(),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            onPressed: (value) {
                              setState(() {
                                dateList.remove(dateTile);
                              });
                            },
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        iconColor: isDateToday(dateTile.date)
                            ? Colors.transparent
                            : null,
                        shape: const BeveledRectangleBorder(),
                        title: Text(
                          getDate(dateTile.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        children: [
                          for (ToDoTileModel event in dateTile.events)
                            LongPressDraggable(
                              onDragCompleted: () =>
                                  onDragComplete(dateTile, event),
                              axis: Axis.vertical,
                              data: event,
                              // feedback shows widget when dragging
                              feedback: SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: Material(
                                  shadowColor: Colors.black,
                                  child: dragTile(event.isChecked, event.text,
                                      Colors.grey.withOpacity(0.5)),
                                ),
                              ),
                              // regular child when not dragged
                              child: Slidable(
                                key: UniqueKey(),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      onPressed: (value) {},
                                      icon: Icons.edit,
                                    ),
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      onPressed: (value) {
                                        setState(() {
                                          dateTile.events.remove(event);
                                        });
                                      },
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),
                                child: dragTile(
                                    event.isChecked, event.text, Colors.white),
                              ),
                            ),
                          // Add List Tile
                          InkWell(
                            onTap: () {
                              setState(() {
                                dateTile.events.add(ToDoTileModel(
                                    date: DateTime.now(),
                                    text: '',
                                    isChecked: ValueNotifier(false)));
                              });
                            },
                            child: const ListTile(
                              dense: true,
                              title: Icon(Icons.add),
                              subtitle: Text(
                                "Add new task or event",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            // Add new date tile
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Icon(Icons.add),
                subtitle: Text(
                  "Add new date",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
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
