import 'package:doers/components/date_tile.dart';
import 'package:doers/models/date_tile_model.dart';
import 'package:doers/models/todo_tile_model.dart';
import 'package:doers/utils.dart';
import 'package:flutter/cupertino.dart';
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

  bool isDraggedToSameDate = false;

  void onAccept(
      DragTargetDetails<ToDoTileModel> receivedData, DateTileModel dateTile) {
    final receivedDate = DateTime(receivedData.data.date.year,
        receivedData.data.date.month, receivedData.data.date.day);
    final dateTileDate =
        DateTime(dateTile.date.year, dateTile.date.month, dateTile.date.day);
    if (receivedDate == dateTileDate) {
      isDraggedToSameDate = true;
      setState(() {});
      return;
    }
    setState(() {
      isDraggedToSameDate = false;
      receivedData.data.date = dateTileDate;
      dateTile.events.add(receivedData.data);
    });
  }

  void onDragComplete(dateTile, event) {
    if (isDraggedToSameDate) return;
    setState(() {
      dateTile.events.remove(event);
    });
  }

  void removeDate(DateTileModel dateTile) {
    setState(() {
      dateList.remove(dateTile);
    });
  }

  List tabList = ["New Date", "New Event"];
  late DateTime selectedDate;

  void onNewEventTap() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DefaultTabController(
              length: tabList.length,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: [
                        for (var tab in tabList)
                          Text(
                            tab,
                            style: const TextStyle(fontSize: 17),
                          )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 180,
                              child: CupertinoDatePicker(
                                minimumDate: DateTime.now(),
                                onDateTimeChanged: (value) {
                                  selectedDate = value;
                                },
                                mode: CupertinoDatePickerMode.date,
                                showDayOfWeek: true,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dateList.add(DateTileModel(
                                          date: selectedDate, events: []));
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "New date has been created!")));
                                  },
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 180,
                              child: CupertinoDatePicker(
                                minimumDate: DateTime.now(),
                                onDateTimeChanged: (value) {
                                  selectedDate = value;
                                },
                                mode: CupertinoDatePickerMode.date,
                                showDayOfWeek: true,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                    hintText: "Your event goes here",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor))),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dateList.add(DateTileModel(
                                          date: selectedDate, events: []));
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "New date has been created!")));
                                  },
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
